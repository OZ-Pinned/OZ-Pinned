// ignore_for_file: library_private_types_in_public_api, avoid_print, avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pinned/pages/test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinned/screens/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pinned/screens/emotion.dart';

final supportedLocales = [Locale('en', 'US'), Locale('ko', 'KR')];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // easylocalization 초기화!
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        // 지원 언어 리스트
        supportedLocales: supportedLocales,
        //path: 언어 파일 경로
        path: 'assets/translations',
        //fallbackLocale supportedLocales에 설정한 언어가 없는 경우 설정되는 언어
        fallbackLocale: Locale('en', 'US'),

        //startLocale을 지정하면 초기 언어가 설정한 언어로 변경됨
        //만일 이 설정을 하지 않으면 OS 언어를 따라 기본 언어가 설정됨
        startLocale: Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // // home: const NamePage(title: 'Input Name'),
        // home:
        // HomePage(email: "test@example.com", character: 1, name: "hyewon"));
        home: SelectPage());
  }
}

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  // selectedChar가 null이면 0을 기본값으로 사용
  bool logined = false;

  @override
  void initState() {
    super.initState();
  }

  void toggleSelect(value) {
    setState(() {
      logined = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Image.asset('assets/images/logo.png'),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 50), // 버튼을 바닥에서 50 픽셀 띄움
              child: SizedBox(
                width: 320,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    toggleSelect(true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailPage(
                          logined: true,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFF516A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                  ),
                  child: Text(
                    tr('start'),
                    style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailPage extends StatefulWidget {
  final bool logined;
  const EmailPage({super.key, required this.logined});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  String inputedEmail = "";
  String helpText = "";

  @override
  void initState() {
    inputedEmail = "";
    super.initState();
  }

  void inputEmail(value) {
    setState(() {
      inputedEmail = value;
      // print(inputedEmail);
    });
  }

  String emailBody = "";

  Future<String> _getEmailBody() async {
    String body = '';
    for (int i = 0; i < 6; i++) {
      var rnd = Random().nextInt(10);
      body += rnd.toString();
    }

    print(body);
    return body;
  }

  Future<void> login(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/user/login'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      final data = json.decode(response.body);

      RegExp regex = RegExp(r'\w+@(gmail\.com|naver\.com)');

      if (regex.hasMatch(inputedEmail)) {
        _sendEmail(inputedEmail);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CertificationPage(
              logined: widget.logined,
              email: inputedEmail,
              certificationCode: emailBody,
            ),
          ),
        );
        print("Signup successful : $data");
      } else {
        setState(() {
          helpText = "이메일을 다시 한 번 확인해 주세요.";
        });
      }

      print("Login failed : ${data['errorMessage']}");
    } catch (error) {
      print(error);
    }
  }

  void _sendEmail(String recipientEmail) async {
    emailBody = await _getEmailBody();
    String username = 'jieyn7@naver.com'; // 본인의 네이버 이메일
    String password = 'NRRZDBB9MXPZ'; // 앱 비밀번호

    final smtpServer = SmtpServer(
      'smtp.naver.com',
      port: 587,
      username: username,
      password: password,
      ignoreBadCertificate: false,
    );

    final message = Message()
      ..from = Address(username)
      ..recipients.add(inputedEmail) // 사용자 이메일
      ..subject = '핀드 인증번호'
      ..text = '인증번호: $emailBody';

    try {
      await send(message, smtpServer);
      print('이메일 전송 성공');
    } catch (e) {
      print('이메일 전송 실패: $e');
      if (e is MailerException) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xfffffffff),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 57,
              ),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center, // 위젯들이 중앙에 정렬되도록 설정
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 280,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white, // 내부 배경색 설정
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide(
                                    color: Color(0xffDADADA), // 외부 테두리 색상
                                    width: 1.0, // 외부 테두리 두께
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffDADADA), // 포커스 시 동일한 색상 유지
                                    width: 1.0, // 외부 테두리 두께
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffDADADA), // 기본 테두리 투명
                                    width: 0, // 두께 0
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                inputEmail(value);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              helpText,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 28, // 텍스트 상자 위에 위치하도록 조정
                        left: 10,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: 2,
                                      bottom: 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xffEDEDED),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(19.5),
                                        topRight: Radius.circular(19.5),
                                        bottomRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(19.5),
                                      ),
                                      border: Border.all(
                                        color: Color(0xffDADADA),
                                      ),
                                    ),
                                    width: 204,
                                    height: 43,
                                    child: Text(
                                      "enter_email",
                                      style: TextStyle(
                                        fontFamily: 'LeeSeoYun',
                                        fontSize: 24,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).tr(),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            SvgPicture.asset(
                              'assets/images/KoKoChar.svg',
                              width: 98,
                              height: 92.5,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      login(inputedEmail);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF516A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                    ),
                    child: Text(
                      "verification_code",
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CertificationPage extends StatefulWidget {
  final bool logined;
  final String email;
  final String certificationCode;
  const CertificationPage({
    super.key,
    required this.logined,
    required this.email,
    required this.certificationCode,
  });

  @override
  _CertificationPageState createState() => _CertificationPageState();
}

class _CertificationPageState extends State<CertificationPage> {
  String userName = "";
  int userCharacter = 0;

  String certifyCode = "";
  String helpText = "";

  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  // 각 TextField에 포커스를 이동하는 함수
  void _onFieldChanged(String value, int index) {
    setState(() {
      // certifyCode 업데이트
      certifyCode = _controllers.map((controller) => controller.text).join();

      if (value.length == 1 && index < 5) {
        // 현재 입력이 1자일 때, 다음 TextField로 포커스를 이동
        FocusScope.of(context).nextFocus();
      } else if (value.isEmpty && index > 0) {
        // 입력값이 없으면 이전 TextField로 포커스를 이동
        FocusScope.of(context).previousFocus();
      }
    });
  }

  Future<void> storeEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email); // 'email' 키에 이메일 저장
  }

  Future<void> login(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/user/login'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      final data = await json.decode(response.body);

      if (data['success']) {
        // 로그인 된 사용자일때
        print("Login successful : $data");
        userName = data['user']['name'];
        userCharacter = data['user']['character'];
        print('$userName $userCharacter');

        if (certifyCode == widget.certificationCode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                name: userName,
                email: widget.email,
                character: userCharacter,
              ),
            ),
          );
        } else {
          setState(() {
            helpText = "인증번호를 확인해 주세요.";
          });
        }

        await storeEmail(email);
      } else {
        if ((certifyCode == widget.certificationCode)) {
          helpText = "";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterPage(
                email: widget.email,
              ),
            ),
          );
        } else {
          setState(() {
            helpText = "인증 코드를 다시 한 번 확인해 주세요.";
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xfffffffff),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.center, // 위젯들이 중앙에 정렬되도록 설정
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) {
                            return SizedBox(
                              width: 50,
                              child: TextField(
                                controller: _controllers[index],
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                maxLength: 1,
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    top: 9.5,
                                    bottom: 9.5,
                                    right: 16,
                                    left: 16,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white, // 내부 배경색 설정
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                      color: Color(0xffDADADA), // 외부 테두리 색상
                                      width: 1.0, // 외부 테두리 두께
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Color(0xffFF324F), // 포커스 시 동일한 색상 유지
                                      width: 1.0, // 외부 테두리 두께
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent, // 기본 테두리 투명
                                      width: 0, // 두께 0
                                    ),
                                  ),
                                  counterText: "", // 글자 수 카운트 텍스트를 숨김
                                ),
                                onChanged: (value) {
                                  _onFieldChanged(
                                      value, index); // 값 변경 시 다음으로 포커스를 이동
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: -115, // 텍스트 상자 위에 위치하도록 조정
                        left: 10,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 2, bottom: 0),
                              decoration: BoxDecoration(
                                color: Color(0xffEDEDED),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(19.5),
                                  topRight: Radius.circular(19.5),
                                  bottomRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(19.5),
                                ),
                                border: Border.all(
                                  color: Color(0xffDADADA),
                                ),
                              ),
                              width: 250, // 너비 확장
                              height: 70, // 높이를 늘려 두 줄이 표시되도록 설정
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  context.locale.languageCode == 'en'
                                      ? "please enter the\nverification code"
                                      : "enter_verification_code",
                                  style: TextStyle(
                                    fontFamily: 'LeeSeoYun',
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center,
                                ).tr(), // 다국어 텍스트 번역
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                SvgPicture.asset(
                                  'assets/images/KoKoChar.svg',
                                  width: 98,
                                  height: 92.5,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        helpText,
                        style: TextStyle(
                          color: Color(0xffFF324F),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 50), // 하단에서 50픽셀 위로 띄움
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await login(widget.email);
                      await storeEmail(widget.email);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF516A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                    ),
                    child: Text(
                      "confirm",
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CharacterPage extends StatefulWidget {
  final String email;

  const CharacterPage({super.key, required this.email});

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  int selectedChar = 0;

  SvgPicture getImage(int value) {
    if (value == 0) {
      return SvgPicture.asset(
        'assets/images/Koala.svg',
        height: 80,
        width: 320,
      );
    } else if (value == 1) {
      return SvgPicture.asset(
        'assets/images/Kangeroo.svg',
        height: 80,
        width: 320,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/Quoka.svg',
        height: 80,
        width: 320,
      );
    }
  }

  String getName(int value) {
    if (value == 0) {
      return tr("coco");
    } else if (value == 1) {
      return tr("ruru");
    } else {
      return tr("kiki");
    }
  }

  void toggleSelect(int value) {
    setState(() {
      selectedChar = value; // 선택된 캐릭터의 인덱스 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xfffffffff),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "choose_character",
              style: TextStyle(
                fontFamily: 'LeeSeoYun',
                fontSize: 24,
              ),
            ).tr(),
            const Text(
              "can_change_character",
              style: TextStyle(
                  fontFamily: 'LeeSeoYun',
                  fontSize: 14,
                  color: Color(0xff888888)),
            ).tr(),
            const SizedBox(height: 35),
            // 캐릭터 선택 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++) ...[
                  Column(
                    children: [
                      SizedBox(
                        width: 110,
                        height: 158,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFFFFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            side: BorderSide(
                              color: selectedChar == i
                                  ? const Color(0xffFB5D6F)
                                  : const Color(0xffDADADA),
                              width: 2.0,
                            ),
                            padding: const EdgeInsets.all(6),
                          ),
                          onPressed: () => toggleSelect(i),
                          child: getImage(i),
                        ),
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      Text(
                        getName(i),
                        style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 25),
                        textAlign: TextAlign.center,
                      ).tr(),
                    ],
                  ),
                  if (i < 2) const SizedBox(width: 6), // 버튼 간 간격
                ],
              ],
            ),
            Spacer(),
            // 다음 버튼
            Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: SizedBox(
                width: 350,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF516A),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelloPage(
                          email: widget.email,
                          character: selectedChar,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "confirm",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).tr(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HelloPage extends StatefulWidget {
  final String email;
  final int character;

  const HelloPage({super.key, required this.email, required this.character});

  @override
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  String getName(int value) {
    if (value == 0) {
      return tr("coco");
    } else if (value == 1) {
      return tr("ruru");
    } else {
      return tr("kiki");
    }
  }

  String getImage(int value) {
    if (value == 0) {
      return 'assets/images/Koala.svg';
    } else if (value == 1) {
      return 'assets/images/Kangeroo.svg';
    } else {
      return 'assets/images/Quoka.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xfffffffff),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.only(
                top: 9,
                bottom: 9,
                right: 44,
                left: 44,
              ),
              decoration: BoxDecoration(
                color: Color(0xffEDEDED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(19.5),
                  topRight: Radius.circular(19.5),
                  bottomRight: Radius.circular(19.5),
                ),
              ),
              child: Text(
                tr("greeting_message",
                    namedArgs: {'character': getName(widget.character)}),
                style: TextStyle(
                  fontFamily: 'LeeSeoYun',
                  fontSize: 27,
                  height: 1.1111111,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.all(
                  Radius.circular(300),
                ),
              ),
              child: Center(
                // 크기를 중앙에 배치
                child: SizedBox(
                  width: 168,
                  height: 247,
                  child: Container(
                    child: SvgPicture.asset(
                      getImage(widget.character),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: SizedBox(
                width: 320,
                height: 52,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF516A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NamePage(
                            email: widget.email,
                            character: widget.character,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'confirm',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr()),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NamePage extends StatefulWidget {
  final String email;
  final int character;
  const NamePage({super.key, required this.email, required this.character});

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  Future<void> storeEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email); // 'email' 키에 이메일 저장
  }

// 회원가입 함수
  Future<void> signup(String email, int character, String name) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/user/signup'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'name': name,
          'character': character,
        }),
      );

      final data = json.decode(response.body);

      if (data['success']) {
        print('Signup successful: $data');
        await storeEmail(email); // 이메일 저장
      } else {
        print('Signup failed: ${data['errorMessage']}');
      }
    } catch (error) {
      print('Error during signup: $error');
    }
  }

  String inputedName = "";

  @override
  void initState() {
    inputedName = "";
    super.initState();
  }

  void inputName(value) {
    setState(() {
      inputedName = value;
      // print(inputedName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xfffffffff),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 57,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center, // 위젯들이 중앙에 정렬되도록 설정
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 250,
                      ),
                      Container(
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white, // 내부 배경색 설정
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(
                                color: Color(0xffDADADA), // 외부 테두리 색상
                                width: 1.0, // 외부 테두리 두께
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffDADADA), // 포커스 시 동일한 색상 유지
                                width: 1.0, // 외부 테두리 두께
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffDADADA), // 기본 테두리 투명
                                width: 0, // 두께 0
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            inputName(value);
                          },
                        ),
                      ),
                      Positioned(
                        top: 28, // 텍스트 상자 위에 위치하도록 조정
                        left: 10,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: 2,
                                      bottom: 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xffEDEDED),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(19.5),
                                        topRight: Radius.circular(19.5),
                                        bottomRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(19.5),
                                      ),
                                      border: Border.all(
                                        color: Color(0xffDADADA),
                                      ),
                                    ),
                                    width: 204,
                                    height: 43,
                                    child: FittedBox(
                                      fit: BoxFit
                                          .scaleDown, // 텍스트가 공간에 맞게 줄어들도록 설정
                                      child: Text(
                                        tr("enter_name"),
                                        style: TextStyle(
                                          fontFamily: 'LeeSeoYun',
                                          fontSize: 24,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            SvgPicture.asset(
                              'assets/images/KoKoChar.svg',
                              width: 98,
                              height: 92.5,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      storeEmail(widget.email);
                      signup(widget.email, widget.character, inputedName);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            email: widget.email,
                            character: widget.character,
                            name: inputedName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF516A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                    ),
                    child: Text(
                      "confirm",
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
