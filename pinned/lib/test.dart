import 'package:flutter/material.dart';
import 'test_list.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int testNum = 0; // 현재 질문 번호
  int totalScore = 0; // 총 점수
  Map<String, dynamic>? selectedAnswer; // 현재 선택된 답변
  List<Map<String, dynamic>> selectedAnswers = []; // 선택된 답변 리스트 추가

  // 답변 버튼 클릭 시 호출
  void answerPressed(Map<String, dynamic> answer) {
    setState(() {
      selectedAnswer = answer; // 선택된 답변 저장
    });
  }

  // 다음 질문 또는 결과 페이지로 이동
  void nextQuestion() {
    if (selectedAnswer != null) {
      setState(() {
        // 선택된 답변을 저장하고 점수 합산
        selectedAnswers.add(selectedAnswer!);
        totalScore += int.parse(selectedAnswer!['score']);
        selectedAnswer = null;
        print(totalScore);

        // 다음 질문으로 이동
        if (testNum < testList.length - 1) {
          testNum++;
        } else {
          // 결과 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                totalScore: totalScore,
                selectedAnswers: selectedAnswers,
              ),
            ),
          );
        }
      });
    }
  }

  // 이전 질문으로 이동
  void prevQuestion() {
    if (testNum > 0) {
      setState(() {
        testNum--; // 질문 번호 감소
        // 이전 질문의 선택 답변 정보 제거
        if (selectedAnswers.isNotEmpty) {
          totalScore -= int.parse(selectedAnswers.removeLast()['score']);
        }
        print(totalScore);
        selectedAnswer = null; // 선택 초기화
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 350,
              height: 9,
              child: LinearProgressIndicator(
                value: (testNum + 1) / testList.length,
                color: Color(0xffFF516A),
                backgroundColor: Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(4.5),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 47),
            child: Text(
              '${testNum + 1}.',
              style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 20),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 48),
              child: SizedBox(
                height: 60,
                child: Text(
                  testList[testNum]['questionText'],
                  style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 22),
                ),
              )),
          ...(testList[testNum]['answers'] as List<Map<String, dynamic>>)
              .map((answer) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: selectedAnswer == answer
                    ? Color(0xffFFF1F1)
                    : Colors.white, // 선택 여부에 따라 배경색 변경
                border: Border.all(
                  color: selectedAnswer == answer
                      ? Color(0xffFF516A)
                      : Color(0xffBBBBBB), // 선택 여부에 따라 테두리 색상 변경
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => answerPressed(answer),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.5, horizontal: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        answer['text'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      if (selectedAnswer == answer)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 81, 106, 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Color(0xffFF516A),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼 간격
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: ElevatedButton(
                  onPressed: testNum > 0 ? prevQuestion : null,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      width: 1.0,
                      color: Color(0xffFF516A),
                    ),
                    fixedSize: Size(170, 50),
                    backgroundColor: testNum > 0 ? Colors.white : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ), // 이전 버튼
                  child: Text(
                    '이전',
                    style: TextStyle(fontSize: 18, color: Color(0xffFF516A)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed: selectedAnswer != null ? nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(170, 50),
                    backgroundColor: selectedAnswer != null
                        ? Color(0xffFF516A)
                        : Color(0xffFFB3B3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ), // 다음 버튼
                  child: Text(
                    testNum < testList.length - 1 ? '다음' : '결과 보기',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  final int totalScore;
  final List selectedAnswers;
  const ResultPage(
      {super.key, required this.totalScore, required this.selectedAnswers});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String today = "";

  @override
  void initState() {
    super.initState();
    getToday(); // 화면 초기화 시 날짜 설정
  }

  void getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String strToday = formatter.format(now);
    setState(() {
      today = strToday; // 날짜를 상태에 저장
    });
  }

  String getReseult(int totalScore) {
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
  }

  @override
  Widget build(BuildContext context) {
    int totalScore = widget.totalScore;
    List selectedAnswers = widget.selectedAnswers;

    return Scaffold(
      appBar: AppBar(
        title: Text('결과'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 73),
        color: Color(0xffFF516A), // 핑크색 배경
        child: Stack(
          children: [
            Positioned(
              left: 20, // 왼쪽 여백
              top: 20, // 상단 여백
              child: Text(
                today,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 기존 내용 유지
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
                    child: Container(
                      alignment: Alignment.center,
                      width: 123,
                      height: 34,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xffFFEEF0)),
                      child: Text(
                        getReseult(totalScore),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFF516A),
                            backgroundColor: Color(0xffFFEEF0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 42),
                  Align(
                    child: Container(
                      padding: EdgeInsets.all(26),
                      width: 320,
                      height: 146,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('중간수준 어찌구.. 저찌구...',
                          style:
                              TextStyle(fontFamily: 'LeeSeoYun', fontSize: 17)),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 153,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/meditationButton.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6.5),
                      SizedBox(
                        height: 120,
                        width: 153,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/chatbotButton.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
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
                            spreadRadius: 10,
                            blurRadius: 17,
                            offset: Offset(-5, -5),
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
                          '${widget.totalScore}점',
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
