import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinned/main.dart';
import 'package:easy_localization/easy_localization.dart';

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
  int selectedChar = 0;
  String userName = "";

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
              data['test']['scores'].map(
                (e) => e['score'].toDouble(),
              ),
            );
            scores =
                scores.sublist((scores.length > 5) ? scores.length - 5 : 0);
            dates = List<String>.from(
              data['test']['scores'].map(
                (e) => e['createdAt'].substring(
                  5,
                ),
              ),
            );
            dates = dates.sublist((dates.length > 5) ? dates.length - 5 : 0);
            selectedChar = data['user']['character'];
            userName = data['user']['name'];
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
      } else {
        print('Error: ${data['message']}');
      }
    } catch (error) {
      print('Error fetching diary: $error');
    }
  }

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
      return tr("coco");
    } else if (value == 1) {
      return tr("ruru");
    } else {
      return tr("kiki");
    }
  }

  void toggleSelect(int value) {
    setState(() {
      selectedChar = value;
      print(value);
      changeCharacter(value); // 선택된 캐릭터의 인덱스 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      extendBody: true,
      extendBodyBehindAppBar: false,
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${userName}${'greeting'.tr()}',
                  style: TextStyle(
                    fontFamily: 'LeeSeoYun',
                    fontSize: 24,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AlertDialog(
                              backgroundColor: Color(0xffFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              content: Container(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  right: 10,
                                  left: 10,
                                  bottom: 0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "logout",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ).tr(),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xffFF516A),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        fixedSize: Size(250, 31),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SelectPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'confirm',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ).tr(),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ).tr(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned.fill(
                              top: -265,
                              child: SvgPicture.asset(
                                'assets/images/dialogKoKo.svg',
                                fit: BoxFit.none,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    backgroundColor: Color(0xffE9E9E9),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'logout',
                    style: TextStyle(color: Color(0xff333333), fontSize: 16),
                  ).tr(),
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
                      'emotion_graph',
                      style: TextStyle(
                        fontFamily: 'LeeSeoYun',
                        fontSize: 18,
                      ),
                    ).tr(),
                    Expanded(
                      child: scores.isEmpty
                          ? Center(child: Text("loading_data").tr())
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
              'change_character',
              style: TextStyle(
                fontFamily: 'LeeSeoYun',
                fontSize: 18,
              ),
            ).tr(),
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
                          onPressed: () => {toggleSelect(i)},
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
                      ).tr(),
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
