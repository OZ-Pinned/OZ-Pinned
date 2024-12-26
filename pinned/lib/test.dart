import 'package:flutter/material.dart';
import 'test_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int testNum = 0;
  int totalScore = 0;
  List<Map<String, dynamic>> selectedAnswers = []; // 선택한 답변 저장

  void answerPressed(Map<String, dynamic> answer) {
    setState(() {
      totalScore += int.parse(answer['score']); // 점수 누적
      selectedAnswers.add(answer); // 선택한 답변 저장

      if (testNum < testList.length - 1) {
        testNum++; // 다음 질문으로 이동
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트'),
      ),
      body: testNum < testList.length
          ? Column(
              children: [
                Text(
                  testList[testNum]['questionText'],
                  style: TextStyle(fontSize: 18),
                ),
                ...(testList[testNum]['answers'] as List<Map<String, dynamic>>)
                    .map((answer) {
                  return ElevatedButton(
                    onPressed: () => answerPressed(answer),
                    child: Text(answer['text']),
                  );
                }).toList(),
              ],
            )
          : Center(
              child: Text('모든 질문에 답변했습니다!'),
            ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int totalScore;
  final List<Map<String, dynamic>> selectedAnswers;

  ResultPage({required this.totalScore, required this.selectedAnswers});

  @override
  Widget build(BuildContext context) {
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
            }).toList(),
            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('처음으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
