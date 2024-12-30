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
          }).toList(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼 간격
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: ElevatedButton(
                  onPressed: testNum > 0 ? prevQuestion : null, // 이전 버튼
                  child: Text(
                    '이전',
                    style: TextStyle(fontSize: 18, color: Color(0xffFF516A)),
                  ),
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
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed:
                      selectedAnswer != null ? nextQuestion : null, // 다음 버튼
                  child: Text(
                    testNum < testList.length - 1 ? '다음' : '결과 보기',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(170, 50),
                    backgroundColor: selectedAnswer != null
                        ? Color(0xffFF516A)
                        : Color(0xffFFB3B3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String strToday = formatter.format(now);
    print(strToday);
    return strToday;
  }

  @override
  Widget build(BuildContext context) {
    int totalScore = widget.totalScore;
    List selectedAnswers = widget.selectedAnswers;
    return Scaffold(
      appBar: AppBar(
        title: Text('결과'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '총 점수: $totalScore',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '선택한 답변:',
              style: TextStyle(fontSize: 18),
            ),
            ...selectedAnswers.map((answer) {
              return Text(
                '- ${answer['text']} (점수: ${answer['score']})',
                style: TextStyle(fontSize: 16),
              );
            }),
            ElevatedButton(onPressed: () => getToday(), child: Text("날짜구하기"))
          ],
        ),
      ),
    );
  }
}
