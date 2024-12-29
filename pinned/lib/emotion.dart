import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmotionPage(),
    );
  }
}

class EmotionPage extends StatefulWidget {
  EmotionPage({Key? key}) : super(key: key); // 기본 생성자 추가

  @override
  State<EmotionPage> createState() => _EmotionPageState();
}

class _EmotionPageState extends State<EmotionPage> {
  double currentValue = 0.0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('emotionPage'),
      ),
      backgroundColor: Color(0xff96BDFF),
      body: Column(
        children: [
          Text(
            '오늘의 기분은 어떤가요?',
            style: TextStyle(
                fontFamily: 'LeeSeoYun', color: Colors.white, fontSize: 26),
          ),
          Image.asset('assets/images/Kangeroo.png'),
          SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Color(0xffFFF2F0), // 슬라이더의 활성화된 트랙 색상
                inactiveTrackColor: Color(0xffFFF2F0), // 비활성화된 트랙 색상
                trackHeight: 17.0, // 트랙 두께
                thumbColor: Color(0xff6499F9), // 슬라이더의 썸(핸들) 색상
                thumbShape: CustomSliderThumbCircle(),
                overlayColor:
                    Colors.blue.withOpacity(0.2), // 썸 클릭 시 나오는 오버레이 색상
                overlayShape:
                    RoundSliderOverlayShape(overlayRadius: 20.0), // 오버레이 크기
                tickMarkShape: RoundSliderTickMarkShape(), // 트랙 위의 점 표시 스타일
                activeTickMarkColor: Color(0xff6499F9), // 활성화된 점 색상
                inactiveTickMarkColor: Color(0xff6499F9), // 비활성화된 점 색상
              ),
              child: Slider(
                value: currentValue,
                max: 100,
                divisions: 3,
                onChanged: (value) => setState(() {
                  currentValue = value;
                }),
              )),
        ],
      ),
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
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

    // 바깥 원
    final Paint outerCirclePaint = Paint()
      ..color = Color(0xff6499F9) // 바깥 원 색상
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 15.0, outerCirclePaint); // 바깥 원의 반지름: 15.0

    // 안쪽 원
    final Paint innerCirclePaint = Paint()
      ..color = Color(0xffCFDDF7) // 안쪽 원 색상
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 7.0, innerCirclePaint); // 안쪽 원의 반지름: 7.0
  }
}
