import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'helloPage.dart';

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
