import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'emailPage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pinned/class/storageService.dart';
import 'package:pinned/pages/home/home.dart';
import 'package:pinned/apis/homeAPI.dart';
import 'dart:convert'; // for jsonDecode

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  final StorageService storage = StorageService();
  // selectedChar가 null이면 0을 기본값으로 사용
  bool logined = false;

  @override
  void initState() {
    super.initState();
    _checkAndRedirectToHome();
  }

  void toggleSelect(value) {
    setState(() {
      logined = value;
    });
  }

  Future<void> _checkAndRedirectToHome() async {
    final tokenInfo = await checkToken();

    if (tokenInfo != null) {
      final String email = tokenInfo['email'];
      final response = await Homeapi.getUser(email);

      if (response != null) {
        final userData = jsonDecode(response.body);

        print(userData['user']['name']);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: userData['user']['email'],
              character: userData['user']['character'],
              name: userData['user']['name'],
            ),
          ),
        );
      } else {
        print('유저 정보 불러오기 실패 😢');
      }
    } else {
      print('토큰 없음 or 만료됨 😶‍🌫️');
    }
  }

  Future<Map<String, dynamic>?> checkToken() async {
    final token = await storage.getData('jwt_token');

    if (token == null || Jwt.isExpired(token)) {
      return null;
    }

    try {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      return payload;
    } catch (e) {
      return null;
    }
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
