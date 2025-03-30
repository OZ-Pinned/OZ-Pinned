import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'viewAllDiaryPage.dart';

class DiaryDetailPage extends StatefulWidget {
  final String? id;
  final String title;
  final String content;
  final String image; // 이미지 URL로 변경
  final String email;
  final int emotion;
  final String color;
  const DiaryDetailPage({
    super.key,
    this.id,
    required this.email,
    required this.title,
    required this.content,
    required this.image, // 이미지 URL로 변경
    required this.emotion,
    required this.color,
  });
  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  int _selectedIndex = 0;

  String getImagePath(int emotion) {
    if (emotion == 0) {
      return 'assets/images/angryEmotionSticker.svg';
    } else if (emotion == 1) {
      return 'assets/images/sadEmotionSticker.svg';
    } else if (emotion == 2) {
      return 'assets/images/noneEmotionSticker.svg';
    } else {
      return 'assets/images/happyEmotionSticker.svg';
    }
  }

  Future<void> uploadDiary(String email, String title, String content,
      String image, String nowDate, Color color, int emotion) async {
    // 요청 데이터 생성
    String hexColor = '#${color.value.toRadixString(16).substring(2)}';
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/diary/upload'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'title': title,
          'diary': content,
          'image': image, // 이미지 URL 전달
          'createdAt': nowDate,
          'color': hexColor,
          'emotion': emotion,
        }),
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
      }
    } catch (e) {
      return;
    }
  }

  Future<void> updateDiary(String email, String id, Color color) async {
    final apiUrl = 'http://localhost:3000/diary/edit'; // 수정 URL
    // 요청 데이터 생성
    String hexColor = '#${color.value.toRadixString(16).substring(2)}';
    Map<String, dynamic> body = {
      'email': email,
      '_id': id, // 업데이트 대상 ID
      'color': hexColor, // 색상만 업데이트
    };
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final updatedEntry = DiaryEntry.fromJson(jsonDecode(response.body));
        Navigator.pop(context, updatedEntry); // 수정된 데이터 반환
      }
    } catch (e) {
      return;
    }
  }

  Future<void> saveOrUpdateDiary(
      String email, String title, String content, String image, int emotion,
      {required String nowDate, required Color color}) async {
    if (widget.id == null) {
      // 업로드
      await uploadDiary(email, title, content, image, nowDate, color, emotion);
    } else if (widget.id != null) {
      // 수정
      await updateDiary(email, widget.id!, color);
    }
  }

  // 상태로 관리될 컨테이너 색상
  String nowdate = DateFormat('yyyy.MM.dd').format(DateTime.now());
  late Color _containerColor;
  bool isFront = true; // true면 이미지가 보이고, false면 빈 화면이 보임
  List<Color> colors = [
    Color(0xFFFFFFFF),
    Color(0xFF555555),
    Color(0xFFF0B8B2),
    Color(0xFFF5DE99),
    Color(0xFFA898C6),
    Color(0xFF9FA9A1)
  ];
  @override
  void initState() {
    super.initState();
    // widget.color 초기화
    _containerColor = Color(int.parse(widget.color.replaceFirst('#', '0xff')));
    _selectedIndex = colors.indexOf(_containerColor);
  }

  void _flipCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        backgroundColor: Color(0xffF8F8F8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        excludeHeaderSemantics: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            GestureDetector(
              onTap: _flipCard,
              child: Stack(
                children: [
                  Container(
                    height: 380,
                    width: 280,
                    decoration: BoxDecoration(
                      color: _containerColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: Offset(0, 4.61),
                          blurRadius: 6.15,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: isFront
                        ? Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                SizedBox(
                                  width: 249,
                                  height: 253,
                                  child: Image.network(
                                    widget.image, // 이미지 URL 사용
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: TextStyle(
                                        fontFamily: 'LeeSeoYun',
                                        fontSize: 28,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      nowdate,
                                      style: TextStyle(
                                        fontFamily: 'LeeSeoYun',
                                        fontSize: 20,
                                        color: Color(0xff888888),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Center(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                widget.content,
                                style: TextStyle(
                                  fontFamily: 'LeeSeoYun',
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                  ),
                  if (isFront)
                    Positioned(
                      bottom: 82,
                      right: 16,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: SvgPicture.asset(
                          getImagePath(widget.emotion),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 275,
              width: double.infinity,
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          tr("color"),
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                6,
                                (index) {
                                  // 상태로 관리될 컨테이너 색상
                                  final List<Color> colors = [
                                    const Color(0xFFFFFFFF),
                                    const Color(0xFF555555),
                                    const Color(0xFFF0B8B2),
                                    const Color(0xFFF5DE99),
                                    const Color(0xFFA898C6),
                                    const Color(0xFF9FA9A1),
                                  ];
                                  return MaterialButton(
                                    height: 60,
                                    onPressed: () {
                                      setState(() {
                                        _containerColor = colors[index];
                                        _selectedIndex =
                                            index; // 선택된 버튼의 인덱스를 기록
                                      });
                                    },
                                    elevation: 0,
                                    color: colors[index],
                                    shape: CircleBorder(
                                      side: BorderSide(
                                        color: _selectedIndex == index
                                            ? Color(0xffFF516A)
                                            : Color(0xffE9E9E9),
                                        width: _selectedIndex == index
                                            ? 2
                                            : 1, // 선택된 버튼에만 보더 색상 변경
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 47),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () async {
                          await saveOrUpdateDiary(
                            widget.email,
                            widget.title,
                            widget.content,
                            widget.image, // 이미지 URL 전달
                            widget.emotion,
                            nowDate: nowdate,
                            color: _containerColor,
                          );
                          setState(() {
                            ViewDiary(widget.email);
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewAllDiaryPage(email: widget.email),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFF516A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                        ),
                        child: Text(
                          tr("complete"),
                          style: TextStyle(
                            fontFamily: 'LeeSeoYun',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
