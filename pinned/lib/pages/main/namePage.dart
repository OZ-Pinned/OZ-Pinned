import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinned/pages/home/home.dart';
import 'package:pinned/apis/mainAPI.dart';

class NamePage extends StatefulWidget {
  final String email;
  final int character;
  const NamePage({super.key, required this.email, required this.character});

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
// 회원가입 함수
  Future<void> signup(String email, int character, String inputedName) async {
    try {
      final response = await Mainapi.signup(email, character, inputedName);
      final data = json.decode(response!.body);
      if (data['success']) {
        print('Signup successful: $data'); // 이메일 저장
      } else {
        print('Signup failed: ${data['errorMessage']}');
      }
    } catch (e) {
      print('Error sign up : $e');
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
