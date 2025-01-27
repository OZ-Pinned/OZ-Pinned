import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinned/apis/diaryAPI.dart';
import 'viewAllDiary.dart';
import 'dart:convert';
import 'viewAllDiary.dart';

class DiaryDetailPage extends StatefulWidget {
  final String? id;
  final String title;
  final String content;
  final Uint8List image;
  final String email;
  final int emotion;
  final String color;
  final int character;
  final String name;

  const DiaryDetailPage({
    super.key,
    this.id,
    required this.email,
    required this.title,
    required this.content,
    required this.image,
    required this.emotion,
    required this.color,
    required this.character,
    required this.name,
  });

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  int _selectedIndex = 0;

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

  Future<void> _saveOrUpdateDiary(
      String email,
      String id,
      String title,
      String content,
      Uint8List? imageBytes,
      int emotion,
      String nowDate,
      Color color) async {
    try {
      final response = await Diaryapi.saveOrUpdateDiary(
          email, id, title, content, imageBytes, emotion,
          nowDate: nowDate, color: color);
      final data = json.decode(response!.body);

      print(data);
    } catch (e) {
      print('Error save or update diary : $e');
    }
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
                          color: Colors.black.withValues(alpha: 0.1), // 그림자 색상
                          offset: Offset(0, 4.61), // 그림자의 위치
                          blurRadius: 6.15, // 그림자의 퍼짐 정도
                          spreadRadius: 0, // 그림자의 확산 정도
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
                                  child: Image.memory(
                                    widget.image,
                                    fit: BoxFit.fill, // 또는 BoxFit.fill로 테스트
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
                              // 뒷면: 본문을 보여줍니다.
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
                          Diaryapi.getImagePath((widget.emotion).toDouble()),
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
                          if (widget.title.isNotEmpty &&
                              widget.content.isNotEmpty) {
                            _saveOrUpdateDiary(
                              widget.email,
                              widget.id ?? '',
                              widget.title,
                              widget.content,
                              widget.image,
                              widget.emotion,
                              nowdate, // 추가로 전달
                              _containerColor,
                            );
                            setState(() {
                              Diaryapi.ViewDiary(widget.email);
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewAllDiaryPage(
                                  email: widget.email,
                                  character: widget.character,
                                  name: widget.name,
                                ),
                              ),
                            );
                          }
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
