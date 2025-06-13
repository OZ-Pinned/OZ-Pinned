import 'dart:math';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pinned/apis/mainAPI.dart';
import 'package:pinned/widgets/messageBox.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinned/pages/home/home.dart';
import 'characterPage.dart';
import 'package:pinned/class/storageService.dart';

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

  final StorageService storage = StorageService();

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
    await storage.saveData('email', email); // FlutterSecureStorage에 이메일 저장
  }

  Future<void> saveToken(String token) async {
    await storage.saveData('jwt_token', token);
  }

  Future<void> login(String email) async {
    try {
      final response = await Mainapi.login(widget.email);
      final data = json.decode(response!.body);

      print(data);

      if (data['success']) {
        userName = data['user']['name'];
        userCharacter = data['user']['character'];

        if (certifyCode == widget.certificationCode) {
          final token = json.decode(response.body)['token'];
          await saveToken(token);

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
      }
    } catch (e) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0x0fffffff),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
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
                        right: 0,
                        child: Row(
                          children: [
                            messageBox(message: "enter_verification_code"),
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
