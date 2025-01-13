import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:pinned/screens/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                Stack(
                  children: [
                    // 물결 배경
                    Positioned.fill(
                      child: WaveCanvas(),
                    ),
                    // 컨텐츠
                    SafeArea(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "오늘의 감정 기록하기",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          // 나머지 컨텐츠 추가
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradientPaint = Paint()
      ..color = Color(0xFFFFFFFF) // 물결 색상
      ..style = PaintingStyle.fill;

    final path = Path();

    // 위쪽 하얀색 영역
    path.lineTo(0, size.height * 0.5); // 하얀색 영역의 아래 경계
    path.lineTo(size.width, size.height * 0.5); // 하얀색 영역의 아래 경계
    path.lineTo(size.width, 0); // 왼쪽 상단
    path.close();
    canvas.drawPath(path, gradientPaint);

    // 물결 경로 생성 (아래쪽 물결)
    final wavePaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFFFFE9EC), Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
          Rect.fromLTRB(0, size.height * 0.5, size.width, size.height))
      ..style = PaintingStyle.fill;

    final wavePath = Path();

    wavePath.moveTo(0, size.height * 0.7); // 물결 시작 위치
    wavePath.quadraticBezierTo(size.width * 0.25, size.height * 0.55,
        size.width * 0.5, size.height * 0.7);
    wavePath.quadraticBezierTo(
        size.width * 0.75, size.height * 0.85, size.width, size.height * 0.7);
    wavePath.lineTo(size.width, size.height); // 물결이 끝나는 지점
    wavePath.lineTo(0, size.height); // 물결이 끝나는 지점
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint); // 물결 그리기
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class WaveCanvas extends StatelessWidget {
  const WaveCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(320, 255), // 사각형 크기 설정
      painter: WavePainter(),
    );
  }
}
