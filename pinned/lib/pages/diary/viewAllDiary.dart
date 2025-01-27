import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'emotion.dart';
import '../home/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinned/pages/diary/diaryDetail.dart';
import 'package:pinned/apis/diaryAPI.dart';

class ViewAllDiaryPage extends StatefulWidget {
  final String email;
  final int character;
  final String name;

  const ViewAllDiaryPage(
      {super.key,
      required this.email,
      required this.character,
      required this.name});

  @override
  _ViewAllDiaryPageState createState() => _ViewAllDiaryPageState();
}

class _ViewAllDiaryPageState extends State<ViewAllDiaryPage> {
  late Future<List> futureDiaries;

  @override
  void initState() {
    super.initState();
    _getAllDiary(widget.email);
  }

  Future<void> _getAllDiary(String email) async {
    try {
      final response = await Diaryapi.ViewDiary(widget.email);
      final data = json.decode(response!.body);

      print(data);

      futureDiaries = data['res'];
    } catch (e) {
      print('Error get all diary : $e');
    }
  }

  void _navigateToHomePage() {
    if (email != null && character != null && name != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            email: email!,
            character: character!,
            name: name!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data not available')),
      );
    }
  }

  void refreshDiaries() {
    setState(() {
      _getAllDiary(widget.email);
    });
  }

  String? email;
  int? character;
  String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateToHomePage,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            FutureBuilder<List>(
              future: futureDiaries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Wrap(
                        spacing: 10, // 카드 간 가로 간격
                        runSpacing: 13, // 카드 간 세로 간격
                        children: List.generate(snapshot.data!.length, (index) {
                          var entry = snapshot.data![index];
                          Color cardColor = Color(
                            int.parse(entry.color
                                .replaceFirst('#', '0xff')), // #을 0xff로 변경
                          );
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 2 -
                                20, // 화면 너비에 따라 자동 조정
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiaryDetailPage(
                                        id: entry.id,
                                        email: entry.email,
                                        title: entry.title,
                                        content: entry.content,
                                        image: base64Decode(entry.image),
                                        emotion: entry.emotion,
                                        color: entry.color,
                                        character: widget.character,
                                        name: widget.name,
                                      ),
                                    ));
                                refreshDiaries(); // 데이터 갱신
                              },
                              child: Card(
                                color: cardColor,
                                shape: RoundedRectangleBorder(
                                    // 카드 모서리 둥글게
                                    ),
                                elevation: 3,
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Center(
                                          child: Image.memory(
                                            base64Decode(entry.image),
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                entry.title,
                                                style: const TextStyle(
                                                  fontFamily: 'LeeSeoYun',
                                                  fontSize: 15, // 제목 폰트 크기
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                DateFormat('yyyy.MM.dd').format(
                                                    DateTime.parse(
                                                        entry.createdAt)),
                                                style: const TextStyle(
                                                  fontFamily: 'LeeSeoYun',
                                                  fontSize: 10, // 날짜 폰트 크기
                                                  color: Color(0xff888888),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      right: 10,
                                      child: SizedBox(
                                        width: 34,
                                        height: 34,
                                        child: SvgPicture.asset(
                                          Diaryapi.getImagePath(entry.emotion),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }
              },
            ),
            Positioned(
              bottom: 40, // 화면 아래에서부터의 거리
              right: 20, // 화면 오른쪽에서부터의 거리
              child: Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xffFF516A), // 원형 배경색
                  shape: BoxShape.circle, // 원형 모양
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmotionPage(
                          email: widget.email,
                          character: widget.character,
                          name: widget.name,
                        ),
                      ),
                    );
                    print("Floating button clicked");
                  },
                  icon: const Icon(Icons.add, size: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
