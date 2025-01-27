import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'emailPage.dart';

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
