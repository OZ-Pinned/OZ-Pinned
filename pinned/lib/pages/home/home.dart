import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:pinned/icon/custom_icon_icons.dart';
import 'package:pinned/pages/chatbot/chatbot.dart';
import 'package:pinned/pages/diary/emotion.dart';
import 'package:pinned/pages/test/test.dart';
import '../mypage/mypage.dart';
import '../meditation/meditation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pinned/apis/homeAPI.dart';
import 'package:pinned/class/storageService.dart';

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
  final StorageService storage = StorageService();

  int selectedChar = 0;

  List pictureList = [
    'smallAngryEmotion.svg',
    'smallSadEmotion.svg',
    'smallNoneEmotion.svg',
    'smallHappyEmotion.svg'
  ];

  List buttonImageList = [
    'meditationButtonBackground.svg',
    'selfTestButtonBackground.svg',
  ];

  String getImage(int value) {
    return pictureList[value];
  }

  String getButtonImage(int value) {
    return buttonImageList[value];
  }

  SvgPicture getCharacter(int value) {
    if (value == 0) {
      return SvgPicture.asset(
        'assets/images/KoKoChar.svg',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      );
    } else if (value == 1) {
      return SvgPicture.asset(
        'assets/images/textRuRu.svg',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/KiKiChar.svg',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      );
    }
  }

  double getTop(int value) {
    if (value == 0) {
      return -58;
    } else if (value == 1) {
      return -70;
    } else {
      return -65;
    }
  }

  double getLeft(int value) {
    if (value == 0) {
      return 10;
    } else if (value == 1) {
      return 10;
    } else {
      return 10;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser(); // 서버에서 데이터 가져오기
    selectedChar = widget.character;
    storage.saveData('email', widget.email);
    storage.saveData('character', widget.character.toString());
    storage.saveData('name', widget.name);
  }

  Future<void> _getUser() async {
    try {
      final response = await Homeapi.getUser(widget.email);
      final data = json.decode(response!.body);

      setState(() {
        // 서버에서 가져온 캐릭터 값을 업데이트
        selectedChar = data['user']['character'];
      });
    } catch (e) {
      return;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: AppBar(
          backgroundColor: Color(0xffFF516A),
          iconTheme: IconThemeData(
            color: Color(0xffFF516A), //색변경
          ),
        ),
      ),
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
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Positioned(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/images/smallLogo.svg'),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xffFFFFFF), // 원하는 배경색
                              shape: BoxShape.circle, // 원형 배경
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyPage(
                                          email: widget.email,
                                          character: selectedChar,
                                        ),
                                      ),
                                    ).then(
                                      (_) {
                                        _getUser();
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    CustomIcon.MyPage,
                                  ),
                                  padding: EdgeInsets.only(right: 0),
                                  iconSize: 26, // 아이콘 크기
                                  color: Color(0xffFF516A), // 아이콘 색상
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        '${widget.name}${'cheer_ment'.tr()}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'LeeSeoYun',
                          fontSize: 26,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                // 감정 기록 부분 수정
                Column(
                  children: [
                    SizedBox(height: 20),
                    SafeArea(
                      child: Container(
                        width: 320,
                        height: 255,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/images/smallBackground.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // 버튼과 중앙 콘텐츠의 배치
                              children: [
                                SizedBox(), // 왼쪽 빈 공간
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmotionPage(
                                          email: widget.email,
                                          // character: widget.character,
                                          // name: widget.name,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.add),
                                  color: Color(0xffFF516A),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              "today_emotion".tr(),
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
                                  SvgPicture.asset(
                                    'assets/images/${getImage(i)}',
                                    fit: BoxFit.cover,
                                    width: 62,
                                    height: 65,
                                  ),

                                  if (i < 3)
                                    const SizedBox(width: 7), // 버튼 간 간격
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 2; i++) ...[
                            Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/${getButtonImage(i)}',
                                  width: 160,
                                  height: 142,
                                  fit: BoxFit.fill,
                                ),
                                Positioned.fill(
                                  top: 40,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(7),
                                      onTap: () {
                                        if (i == 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MeditationVideoList(),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TestPage(
                                                email: widget.email,
                                                name: widget.name,
                                                character: widget.character,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          i == 0
                                              ? 'Go Meditation'
                                              : 'Self-diagnosis',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: 'LeeSeoYun',
                                          ),
                                        ).tr(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (i < 1) const SizedBox(width: 5),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Stack(
                              alignment: Alignment.center, // 위젯들이 중앙에 정렬되도록 설정
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: 9,
                                    bottom: 9,
                                    right: 44,
                                    left: 44,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
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
                                  width: 246,
                                  height: 58,
                                  child: Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      '${widget.name}${"how_was_your_day".tr()}',
                                      style: TextStyle(
                                        fontFamily: 'LeeSeoYun',
                                        fontSize: 18,
                                        height: 1.14,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: getTop(
                                      selectedChar), // 텍스트 상자 위에 위치하도록 조정
                                  left: getLeft(selectedChar),
                                  child: getCharacter(selectedChar),
                                ),
                              ],
                            ),
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: Color(0xffFF516A), // 원하는 배경색
                                shape: BoxShape.circle, // 원형 배경
                              ),
                              child: Center(
                                // 아이콘을 가운데 배치
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatBot(
                                          email: widget.email,
                                          name: widget.name,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(CustomIcon.ChatAI),
                                  iconSize: 48, // 아이콘 크기
                                  color: Colors.white, // 아이콘 색상
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
