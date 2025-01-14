import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPage extends StatefulWidget {
  final String email;
  final int character;
  const MyPage({super.key, required this.email, required this.character});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<double> scores = []; // 점수 데이터를 double로 저장
  List<String> dates = [];

  @override
  void initState() {
    super.initState();
    // 위젯이 초기화될 때 getTest 호출
    getTest();
  }

  Future<void> getTest() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/mypage/get/${widget.email}'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body);
      print(data);
      if (data['success']) {
        // 데이터 변환
        setState(
          () {
            scores = List<double>.from(
              data['test'][0]['scores'].map(
                (e) => e['score'].toDouble(),
              ),
            );
            dates = List<String>.from(
              data['test'][0]['scores'].map(
                (e) => e['createdAt'].substring(
                  5,
                ),
              ),
            );
          },
        );
      } else {
        print('Error: ${data['message']}');
      }
    } catch (error) {
      print('Error fetching test: $error');
    }
  }

  Future<void> changeCharacter(int character) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/mypage/change/${widget.email}'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'character': character,
        }),
      );

      final data = jsonDecode(response.body);
      print('Response body: ${response.body}');

      if (data['success']) {
        print(data);
        print('교체 성공!');
      } else {
        print('Error: ${data['message']}');
      }
    } catch (error) {
      print('Error fetching diary: $error');
    }
  }

  int selectedChar = 0;

  SvgPicture getImage(int value) {
    if (value == 0) {
      return SvgPicture.asset(
        'assets/images/Koala.svg',
        height: 80,
        width: 320,
      );
    } else if (value == 1) {
      return SvgPicture.asset(
        'assets/images/Kangeroo.svg',
        height: 80,
        width: 320,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/Quoka.svg',
        height: 80,
        width: 320,
      );
    }
  }

  String getName(int value) {
    if (value == 0) {
      return "코코";
    } else if (value == 1) {
      return "루루";
    } else {
      return "키키";
    }
  }

  void toggleSelect(int value) {
    setState(() {
      selectedChar = value;
      changeCharacter(selectedChar); // 선택된 캐릭터의 인덱스 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(title: Text("My Page")),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(67, 35),
                    backgroundColor: Color(0xffE9E9E9),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: Text(
                    '로그아웃',
                    style: TextStyle(color: Color(0xff333333)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 32 / 29,
              child: Container(
                padding:
                    EdgeInsets.only(top: 18, bottom: 18, right: 22, left: 22),
                decoration: BoxDecoration(
                  color: Color(0xffF8F8F8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '감정 그래프',
                      style: TextStyle(
                        fontFamily: 'LeeSeoYun',
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: scores.isEmpty
                          ? Center(child: Text("데이터를 불러오는 중입니다..."))
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 36),
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawHorizontalLine: true,
                                      drawVerticalLine: false,
                                      getDrawingHorizontalLine: (value) =>
                                          FlLine(
                                        color: Color(0xffe0e0e0), // 격자선 색상
                                        strokeWidth: 1,
                                      ),
                                      horizontalInterval: 10,
                                    ),
                                    titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                            getTitlesWidget: (value, meta) {
                                              if (value % 10 == 0) {
                                                return Text(
                                                  '${value.toInt()}',
                                                  style: TextStyle(
                                                    color: Color(0xff7589a2),
                                                    fontSize: 12,
                                                  ),
                                                );
                                              }
                                              return Container();
                                            },
                                            interval: 10,
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                            getTitlesWidget: (value, meta) {
                                              if (value.toInt() <
                                                  dates.length) {
                                                return Text(
                                                  dates[value.toInt()],
                                                  style: TextStyle(
                                                    color: Color(0xff7589a2),
                                                    fontSize: 12,
                                                  ),
                                                );
                                              }
                                              return Container();
                                            },
                                            interval: 1,
                                          ),
                                        ),
                                        topTitles: AxisTitles(),
                                        rightTitles: AxisTitles()),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0xffCCCCCC),
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Color(0xffCCCCCC),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    minX: 0,
                                    maxX: 4,
                                    minY: 0,
                                    maxY: 30, // Y축 최대값 설정
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: scores
                                            .asMap()
                                            .entries
                                            .map((entry) => FlSpot(
                                                  entry.key.toDouble(),
                                                  entry.value,
                                                ))
                                            .toList(),
                                        isCurved: false,
                                        color: Color(0xffFF5C5C), // 선 색상
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(
                                          show: true,

                                          checkToShowDot: (spot, _) =>
                                              true, // 모든 점 표시
                                        ),
                                        belowBarData: BarAreaData(show: false),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              '캐릭터 바꾸기',
              style: TextStyle(
                fontFamily: 'LeeSeoYun',
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 21,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++) ...[
                  Column(
                    children: [
                      SizedBox(
                        width: 103,
                        height: 142,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFFFFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            side: BorderSide(
                              color: selectedChar == i
                                  ? const Color(0xffFB5D6F)
                                  : const Color(0xffDADADA),
                              width: 2.0,
                            ),
                            padding: const EdgeInsets.all(6),
                          ),
                          onPressed: () => toggleSelect(i),
                          child: getImage(i),
                        ),
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      Text(
                        getName(i),
                        style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  if (i < 2) const SizedBox(width: 19), // 버튼 간 간격
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
