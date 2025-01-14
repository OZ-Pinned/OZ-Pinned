import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:pinned/screens/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'meditation.dart';
import 'test.dart';

class HomePage extends StatefulWidget {
  final String email;
  final int character;
  final String name;
  const HomePage({
    super.key,
    required this.email,
    required this.character,
    required this.name,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pictureList = [
    'smallAngryEmotion.svg',
    'smallSadEmotion.svg',
    'smallNoneEmotion.svg',
    'smallHappyEmotion.svg'
  ];

  List buttonImageList = [
    'meditationButton.svg',
    'selfTestButton.svg',
  ];

  String getImage(int value) {
    return pictureList[value];
  }

  String getButtonImage(int value) {
    return buttonImageList[value];
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email'); // 'email' 키에 저장된 값 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // 배경 SVG 이미지
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/homeBackground.svg', // 배경 SVG 이미지 경로
              fit: BoxFit.cover, // 이미지 크기 조정 방식
            ),
          ),
          // 위에 올려 놓을 다른 UI 요소들
          Padding(
            padding: EdgeInsets.only(
              top: 13,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/smallLogo.svg'),
                    IconButton(
                      icon: Icon(Icons.person_3_outlined),
                      padding: EdgeInsets.all(0),
                      color: Color(0xffFFFFFF),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestPage(
                              lang: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  '${widget.name}아, 수고했어!',
                  style: TextStyle(
                    fontFamily: 'LeeSeoYun',
                    fontSize: 26,
                    color: Color(0xffFFFFFF),
                  ),
                ),
                // 감정 기록 부분 수정
                SizedBox(height: 20),
                SafeArea(
                  child: Container(
                    width: 320,
                    height: 255,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/smallBackground.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween, // 버튼과 중앙 콘텐츠의 배치
                          children: [
                            SizedBox(), // 왼쪽 빈 공간
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.add),
                              color: Color(0xffFF516A),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          "오늘의 감정 기록하기",
                          style: TextStyle(
                            fontFamily: 'LeeSeoYun',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < 4; i++) ...[
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  padding: EdgeInsets.all(0),
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/${getImage(i)}',
                                  width: 62,
                                  height: 65,
                                ),
                              ),
                              if (i < 3) const SizedBox(width: 7), // 버튼 간 간격
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 2; i++) ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            padding: EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            if (i == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TestPage(lang: false),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TestPage(lang: true),
                                ),
                              );
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/images/${getButtonImage(i)}',
                            width: 153,
                            height: 135,
                          ),
                        ),
                        if (i < 1) const SizedBox(width: 13),
                      ],
                    ],
                  ),
                )
                // 컨텐츠
              ],
            ),
          ),
        ],
      ),
    );
  }
}
