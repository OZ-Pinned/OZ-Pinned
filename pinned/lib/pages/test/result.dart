import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../meditation/meditation.dart';
import '../chatbot/chatbot.dart';
import 'package:pinned/apis/testAPI.dart';

class ResultPage extends StatefulWidget {
  final int totalScore;
  final List selectedAnswers;
  final String email;
  final String name;
  const ResultPage({
    super.key,
    required this.totalScore,
    required this.selectedAnswers,
    required this.email,
    required this.name,
  });

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String today = "";
  String lan = "";

  @override
  void initState() {
    super.initState();
    getToday();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    lan = Localizations.localeOf(context).languageCode;
  }

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy.MM.dd');
    String strToday = formatter.format(now);

    return strToday;
  }

  String getTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('H:m');
    String strToday = formatter.format(now);

    return strToday;
  }

  String getResult(int totalScore) {
    if (lan != "en") {
      if (totalScore >= 20) {
        return "매우 심함";
      } else if (totalScore >= 15) {
        return "약간 심함";
      } else if (totalScore >= 10) {
        return "중간";
      } else if (totalScore >= 5) {
        return "경미";
      } else
        return "정상";
    } else {
      if (totalScore >= 20) {
        return "Severe Level";
      } else if (totalScore >= 15) {
        return "Mildly Severe Level";
      } else if (totalScore >= 10) {
        return "Moderate Level";
      } else if (totalScore >= 5) {
        return "Mild Leve";
      } else
        return "Normal";
    }
  }

  String getResultContent(int totalScore) {
    _saveScore(widget.email, totalScore);
    if (lan != "en") {
      if (totalScore >= 20) {
        return "광범위한 우을 증상을 매우 자주, 심한 수준에서 경험하는 것으로 보고하였습니다.\n일상생활의 다양한 영역에서 어려움이 초래될 경우 정신건강 전문가의 도움을 받는 것을 권해드립니다.";
      } else if (totalScore >= 15) {
        return "약간 심한 수준의 우울감을 자주 경험하는 것으로 보고하였습니다.\n직업적/사회적 적응에 일부 영향을 미칠 경우 정신건강 전문가의 도움을 받아 보시기를 권해 드립니다.";
      } else if (totalScore >= 10) {
        return "중간 수준의 우울감을 비교적 자주 경험하는 것으로 보고하였습니다.\n직업적/사회적 적응에 일부 영향을 미칠 수 있어 주의 깊은 관찰과 관심이 필요합니다.";
      } else if (totalScore >= 5) {
        return "경미한 수준의 우울감이 있으나 일상생활에 지장을 줄 정도는 아닙니다.";
      } else {
        return "적응상의 지장을 초래할만한 우울 관련 증상을 거의 보고하지 않았습니다.";
      }
    } else {
      if (totalScore >= 20) {
        return "You experience severe symptoms of depression very frequently. If difficulties persist across various areas of daily life, additional evaluation and assistance from a mental health professional are strongly advised.";
      } else if (totalScore >= 15) {
        return "You frequently experience mildly severe levels of depression, which may affect your professional and social functioning. It is recommended to seek help from a mental health professional.";
      } else if (totalScore >= 10) {
        return "You frequently experience moderate levels of depression. It may have some impact on your professional or social life, so careful attention and interest are required.";
      } else if (totalScore >= 5) {
        return "You experience mild levels of depression, but it does not significantly interfere with daily life.";
      } else {
        return "You have reported almost no symptoms of depression exceeding normal adjustment levels.";
      }
    }
  }

  Future<void> _saveScore(String email, int value) async {
    try {
      await Testapi.saveTestScore(email, value);
    } catch (e) {
      return;
    }
  }

  List buttonImageList = [
    'testMeditationButtonBackground.svg',
    'testChatbotButtonBackground.svg',
  ];

  String getButtonImage(int value) {
    return buttonImageList[value];
  }

  @override
  Widget build(BuildContext context) {
    int totalScore = widget.totalScore;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFF516A),
        iconTheme: IconThemeData(
          color: Color(0xffFFFFFF), //색변경
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 60),
        color: Color(0xffFF516A), // 핑크색 배경
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        PieChartView(
                          totalScore: totalScore,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 19),
                  Align(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        alignment: Alignment.center,
                        height: 34,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xffFFEEF0)),
                        child: Text(
                          getResult(totalScore),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffFF516A),
                              backgroundColor: Color(0xffFFEEF0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 42),
                  Align(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: 320,
                      height: 146,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        getResultContent(totalScore),
                        style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 2; i++) ...[
                        Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/images/${getButtonImage(i)}',
                              width: 143,
                              height: 122,
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
                                          builder: (context) => ChatBot(
                                            email: widget.email,
                                            name: widget.name,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      i == 0
                                          ? tr("test_meditation")
                                          : tr("test_chat"),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: 'LeeSeoYun',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (i < 1) const SizedBox(width: 10),
                      ],
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
            Positioned(
                left: 20, // 왼쪽 여백
                top: -35, // 상단 여백
                child: Row(
                  children: [
                    Text(
                      '${getToday()}  ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      getTime(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class PieChartView extends StatefulWidget {
  final int totalScore;
  const PieChartView({super.key, required this.totalScore});

  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    double maxTotal = 30;
    double fillRatio = widget.totalScore / maxTotal;

    _animation = Tween<double>(begin: 0, end: fillRatio).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              double size = 172;
              double innerCircleSize = 110;

              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: size,
                      height: size,
                      decoration: const BoxDecoration(
                        color: Color(0xffF4F4F4),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: Offset(0, 0),
                            color: Colors.white,
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        painter: PieChartPainter(_animation.value),
                      ),
                    ),
                    Container(
                      width: innerCircleSize,
                      height: innerCircleSize,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 10,
                              blurRadius: 17,
                              offset: Offset(1, 2),
                              color: Color(0x21000000),
                            ),
                          ]),
                      child: Center(
                        child: Text(
                          '${widget.totalScore}${tr("score")}',
                          style: const TextStyle(
                            fontSize: 37,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double fillRatio;

  PieChartPainter(this.fillRatio);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xffFF516A)
      ..style = PaintingStyle.fill;

    // 원의 중심과 반지름을 계산
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // 채워질 부분의 각도 계산 (360도 * 채워질 비율)
    double sweepAngle = 2 * 3.14159 * fillRatio;

    // 원 그리기
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // 시작 각도 (위쪽부터 시작)
      sweepAngle, // 채워지는 각도
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
