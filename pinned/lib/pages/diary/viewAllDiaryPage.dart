import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'emotion.dart';
import 'package:pinned/pages/home/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'diaryDetailPage.dart';
import 'package:pinned/class/storageService.dart';

class DiaryEntry {
  final String id;
  final String email;
  final String title;
  final String content;
  final String image;
  final String createdAt;
  final String color;
  final int emotion;
  DiaryEntry(
      {required this.id,
      required this.email,
      required this.title,
      required this.content,
      required this.image,
      required this.createdAt,
      required this.color,
      required this.emotion});
  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      title: json['title'] ?? 'Untitled',
      content: json['diary'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['createdAt'] ?? '',
      color: json['color'] ?? '#F5DE99',
      emotion: int.tryParse(json['emotion'].toString()) ?? 0,
    );
  }
}

Future<List<DiaryEntry>> ViewDiary(String email) async {
  try {
    final response = await http.get(
      Uri.parse('192.168.0.65:3000/diary/get/$email'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['diary'] != null) {
        return (data['diary'] as List)
            .map((diary) =>
                DiaryEntry.fromJson(Map<String, dynamic>.from(diary)))
            .toList();
      }
    }
    throw Exception('Failed to fetch diaries. Status: ${response.statusCode}');
  } catch (e) {
    rethrow;
  }
}

class ViewAllDiaryPage extends StatefulWidget {
  final String email;
  const ViewAllDiaryPage({super.key, required this.email});
  @override
  _ViewAllDiaryPageState createState() => _ViewAllDiaryPageState();
}

class _ViewAllDiaryPageState extends State<ViewAllDiaryPage> {
  final StorageService storage = StorageService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    futureDiaries = ViewDiary(widget.email);
  }

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

  Future<void> _loadUserData() async {
    String savedEmail = await storage.getData('email') ?? '';
    String savedCharacter = await storage.getData('character') ?? '';
    String savedName = await storage.getData('name') ?? '';

    print("$savedEmail$savedCharacter $savedName");
    setState(() {
      email = savedEmail;
      character = int.tryParse(savedCharacter);
      name = savedName;
    });
  }

  void _navigateToHomePage() {
    print("$email $character $name");
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
      futureDiaries = ViewDiary(widget.email);
    });
  }

  late Future<List<DiaryEntry>> futureDiaries;
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
            FutureBuilder<List<DiaryEntry>>(
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
                          DiaryEntry entry = snapshot.data![index];
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
                                        image: entry.image,
                                        emotion: entry.emotion,
                                        color: entry.color,
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
                                          child: Image.network(
                                            entry.image,
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
                                          getImagePath(entry.emotion),
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
                        builder: (context) => EmotionPage(email: widget.email),
                      ),
                    );
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
