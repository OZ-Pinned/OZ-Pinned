import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';
import 'package:pinned/apis/mainAPI.dart';
import 'dart:convert';
import 'certificationPage.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      print(inputedEmail);
    });
  }

  String emailBody = "";

  Future<void> sendEmail(String email) async {
    try {
      final response = await Mainapi.sendEmail(email);
      final data = json.decode(response!.body);

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
    } catch (e) {
      print('Error login : $e');
    }
  }

  Future<String> _getEmailBody() async {
    String body = '';
    for (int i = 0; i < 6; i++) {
      var rnd = Random().nextInt(10);
      body += rnd.toString();
    }

    print(body);
    return body;
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
                      sendEmail(inputedEmail);
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
