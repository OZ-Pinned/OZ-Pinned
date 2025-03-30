import 'package:flutter/material.dart';
import 'package:pinned/class/storageService.dart';
import 'testList/KoreanList.dart';
import 'testList/EnglishList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pinned/pages/test/result.dart';

class TestPage extends StatefulWidget {
  final String email;
  final String name;
  const TestPage({super.key, required this.email, required this.name});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with WidgetsBindingObserver {
  late List<Map<String, dynamic>> testList;
  final StorageService storage = StorageService();

  int testNum = 0; // 현재 질문 번호
  int totalScore = 0; // 총 점수
  Map<String, dynamic>? selectedAnswer; // 현재 선택된 답변
  List<Map<String, dynamic>> selectedAnswers = []; // 선택된 답변 리스트 추가
  bool _isPopupShown = false;
  String lan = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    lan = Localizations.localeOf(context).languageCode;
    testList = Localizations.localeOf(context).languageCode == 'en'
        ? englishList
        : koreanList;

    if (!_isPopupShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPopup();
        _isPopupShown = true; // 팝업 표시 상태 업데이트
      });
    }
  }

// 팝업 표시 함수
  void showPopup() async {
    String savedHasSeenPopup = await storage.getData('hasSeenPopup') ?? 'true';
    bool hasSeenPopup = bool.tryParse(savedHasSeenPopup) ?? false;

    // 팝업이 이전에 표시되지 않았을 때만 실행
    if (!hasSeenPopup) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "지난 2주 이내의 감정을\n바탕으로 선택해주세요!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF516A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: Size(201, 31),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '확인',
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      storage.saveData('hasSeenPopup', 'true');
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "다시 보지 않기",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn); // 부모의 setState 호출

    // 조건에 따라 testList 초기화 (setState 내부에서 초기화하는 것이 아닌, 이미 초기화된 상태에서 업데이트 필요)
    if (lan == 'en') {
      testList = englishList;
    } else {
      testList = koreanList;
    }
  }

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
                email: widget.email,
                name: widget.name,
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
        selectedAnswer = null; // 선택 초기화
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                    tr("before"),
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
                    testNum < testList.length - 1 ? tr("next") : tr("result"),
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
