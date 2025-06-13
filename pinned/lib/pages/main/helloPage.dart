import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'namePage.dart';

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
