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
    futureDiaries = _getAllDiary(widget.email); // 초기화
  }

  Future<List> _getAllDiary(String email) async {
    try {
      final response = await Diaryapi.ViewDiary(email);
      final data = json.decode(response!.body);

      print(data);

      return data['diary']; // 서버 응답의 'res'를 반환
    } catch (e) {
      print('Error get all diary: $e');
      return []; // 에러 발생 시 빈 리스트 반환
    }
  }

  void refreshDiaries() {
    setState(() {
      futureDiaries = _getAllDiary(widget.email); // 데이터 갱신
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
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
                        spacing: 10,
                        runSpacing: 13,
                        children: List.generate(snapshot.data!.length, (index) {
                          var entry = snapshot.data![index];
                          Color cardColor = Color(
                            int.parse(entry['color']
                                .replaceFirst('#', '0xff')), // #을 0xff로 변경
                          );
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            child: GestureDetector(
                              onTap: () {
                                print(widget.character);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiaryDetailPage(
                                      id: entry['_id'],
                                      email: entry['email'],
                                      title: entry['title'],
                                      content: entry['content'],
                                      image: base64Decode(entry['image']),
                                      emotion: entry['emotion'],
                                      color: entry['color'],
                                      character: widget.character,
                                      name: widget.name,
                                    ),
                                  ),
                                ).then((_) => refreshDiaries()); // 데이터 갱신
                              },
                              child: Card(
                                color: cardColor,
                                shape: RoundedRectangleBorder(),
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
                                            base64Decode(entry['image']),
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
                                                entry['title'],
                                                style: const TextStyle(
                                                  fontFamily: 'LeeSeoYun',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                DateFormat('yyyy.MM.dd').format(
                                                    DateTime.parse(
                                                        entry['createdAt'])),
                                                style: const TextStyle(
                                                  fontFamily: 'LeeSeoYun',
                                                  fontSize: 10,
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
                                          Diaryapi.getImagePath(
                                              (entry['emotion']).toDouble()),
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
          ],
        ),
      ),
    );
  }
}
