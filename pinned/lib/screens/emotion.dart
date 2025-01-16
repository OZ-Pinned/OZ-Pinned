import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'gallery_write.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmotionPage(
        email: "test@example.com",
      ),
    );
  }
}

class EmotionPage extends StatefulWidget {
  final String email;
  const EmotionPage({super.key, required this.email}); // 기본 생성자 추가

  @override
  State<EmotionPage> createState() => _EmotionPageState();
}

class _EmotionPageState extends State<EmotionPage> {
  double currentValue = 0.0;

  String getImagePath(double value) {
    if (value <= 25) {
      return 'assets/images/angryEmotion.svg'; // 슬라이더 값이 0~25일 때
    } else if (value <= 50) {
      return 'assets/images/sadEmotion.svg'; // 슬라이더 값이 26~50일 때
    } else if (value <= 75) {
      return 'assets/images/noneEmotion.svg'; // 슬라이더 값이 51~75일 때
    } else {
      return 'assets/images/happyEmotion.svg'; // 슬라이더 값이 76~100일 때
    }
  }

  Color getColorCode(double value) {
    if (value <= 25) {
      return Color(0xff96BDFF); // 슬라이더 값이 0~25일 때
    } else if (value <= 50) {
      return Color(0xff59F09F); // 슬라이더 값이 26~50일 때
    } else if (value <= 75) {
      return Color(0xffFFD751); // 슬라이더 값이 51~75일 때
    } else {
      return Color(0xffFFAE51); // 슬라이더 값이 76~100일 때
    }
  }

  Color getOuterCircleColorCode(double value) {
    if (value <= 25) {
      return Color(0xff6499F9); // 슬라이더 값이 0~25일 때
    } else if (value <= 50) {
      return Color(0xff1BDC74); // 슬라이더 값이 26~50일 때
    } else if (value <= 75) {
      return Color(0xffF2BC02); // 슬라이더 값이 51~75일 때
    } else {
      return Color(0xffF28202); // 슬라이더 값이 76~100일 때
    }
  }

  Color getInnerCircleColorCode(double value) {
    if (value <= 25) {
      return Color(0xffCFDDF7); // 슬라이더 값이 0~25일 때
    } else if (value <= 50) {
      return Color(0xff9BF9CD); // 슬라이더 값이 26~50일 때
    } else if (value <= 75) {
      return Color(0xffFAEA9B); // 슬라이더 값이 51~75일 때
    } else {
      return Color(0xffFAD19B); // 슬라이더 값이 76~100일 때
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorCode(currentValue),
      ),
      backgroundColor: getColorCode(currentValue),
      body: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 75,
            ),
            Text(
              '오늘의 기분은 어떤가요?',
              style: TextStyle(
                  fontFamily: 'LeeSeoYun', color: Colors.white, fontSize: 26),
            ),
            SizedBox(
              height: 93,
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300), // 애니메이션 속도 설정
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                      opacity: animation, child: child); // 페이드 효과
                },
                child: SizedBox(
                  key: ValueKey<double>(
                      currentValue), // 슬라이더 값에 따라 다른 키를 설정하여 애니메이션 적용
                  height: 181,
                  width: 350,
                  child: SvgPicture.asset(
                    getImagePath(currentValue),
                    fit: BoxFit.contain, // 이미지를 중앙에 맞춰줍니다.
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 138,
            ),
            SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xffFFF2F0), // 슬라이더의 활성화된 트랙 색상
                  inactiveTrackColor: Color(0xffFFF2F0), // 비활성화된 트랙 색상
                  trackHeight: 17.0, // 트랙 두께
                  thumbColor: Color(0xff6499F9), // 슬라이더의 썸(핸들) 색상
                  thumbShape: CustomSliderThumbCircle(
                      thumbColor: getOuterCircleColorCode(currentValue),
                      innerCircleColor: getInnerCircleColorCode(currentValue)),
                  overlayColor: Colors.blue.withValues(
                    alpha: 2.0,
                  ), // 썸 클릭 시 나오는 오버레이 색상
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 20.0,
                  ), // 오버레이 크기
                  tickMarkShape: RoundSliderTickMarkShape(), // 트랙 위의 점 표시 스타일
                  activeTickMarkColor:
                      getOuterCircleColorCode(currentValue), // 활성화된 점 색상
                  inactiveTickMarkColor:
                      getOuterCircleColorCode(currentValue), // 비활성화된 점 색상
                ),
                child: Slider(
                  value: currentValue,
                  max: 100,
                  divisions: 3,
                  onChanged: (value) => setState(() {
                    currentValue = value;
                  }),
                )),
            SizedBox(
              height: 78,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteGalleryPage(
                      email: "test@example.com",
                      emotion: (currentValue / 25).toInt(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: Size(350, 48),
              ),
              child: Text(
                '다음',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final Color thumbColor;
  final Color innerCircleColor;

  CustomSliderThumbCircle({
    required this.thumbColor,
    required this.innerCircleColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(30.0, 30.0); // thumb 크기 설정
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    final Canvas canvas = context.canvas;

    // 바깥 원 (thumb)
    final Paint outerCirclePaint = Paint()
      ..color = thumbColor // 전달받은 색상 사용
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 15.0, outerCirclePaint); // 바깥 원의 반지름

    // 안쪽 원
    final Paint innerCirclePaint = Paint()
      ..color = innerCircleColor // 전달받은 색상 사용
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 7.0, innerCirclePaint); // 안쪽 원의 반지름
  }
}
