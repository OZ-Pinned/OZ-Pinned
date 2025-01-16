import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'emotion.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WriteGalleryPage(
        email: "test@example.com",
        emotion: 2,
      ),
    );
  }
}

class WriteGalleryPage extends StatefulWidget {
  final int emotion;
  final String email;

  const WriteGalleryPage(
      {super.key, required this.email, required this.emotion});

  @override
  State<WriteGalleryPage> createState() => _WriteGalleryPageState();
}

String getImagePath(int emotion) {
  if (emotion <= 25) {
    return 'assets/images/angryEmotionSticker.svg';
  } else if (emotion <= 50) {
    return 'assets/images/sadEmotionSticker.svg';
  } else if (emotion <= 75) {
    return 'assets/images/noneEmotionSticker.svg';
  } else {
    return 'assets/images/happyEmotionSticker.svg';
  }
}

class _WriteGalleryPageState extends State<WriteGalleryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Uint8List? _pickedImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List imageData = await image.readAsBytes();
      setState(() {
        _pickedImage = imageData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String nowdate = DateFormat('yyyy.MM.dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        title: const Text('감정 갤러리'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InkWell(
              onTap: pickImage,
              child: Container(
                height: 200,
                color: Color(0x0fffffff),
                alignment: Alignment.center,
                child: _pickedImage == null
                    ? const Icon(Icons.add_a_photo, size: 30)
                    : Image.memory(_pickedImage!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontFamily: 'LeeSeoYun',
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xffF4F4F4),
                labelText: '제목을 작성해주세요.',
                labelStyle: TextStyle(
                  fontFamily: 'LeeSeoYun', // 폰트 패밀리 설정
                  color: Color(0xff888888), // 라벨 색상
                  fontSize: 18, // 라벨 글자 크기
                ),
                enabledBorder: InputBorder.none,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              style: TextStyle(
                fontFamily: 'LeeSeoYun',
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xffF4F4F4),
                labelText: '본문을 작성해주세요.',
                labelStyle: TextStyle(
                  fontFamily: 'LeeSeoYun', // 폰트 패밀리 설정
                  color: Color(0xff888888), // 라벨 색상
                  fontSize: 18, // 라벨 글자 크기
                ),
                enabledBorder: InputBorder.none,
              ),
              maxLines: 6, // 텍스트 필드 세로
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 130), // 버튼과 입력 필드 간 간격
            SizedBox(
              width: 320, // 버튼 너비
              height: 52, // 버튼 높이
              child: ElevatedButton(
                onPressed: () {
                  if (_pickedImage != null &&
                      _titleController.text.isNotEmpty &&
                      _contentController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryDetailPage(
                          id: null,
                          title: _titleController.text,
                          content: _contentController.text,
                          image: _pickedImage!,
                          email: widget.email,
                          emotion: widget.emotion,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('이미지와 제목, 본문을 모두 입력해주세요.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFF516A), // 버튼 배경색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)), // 테두리
                  ),
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(
                    fontFamily: 'LeeSeoYun',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

class DiaryDetailPage extends StatefulWidget {
  final String? id;
  final String title;
  final String content;
  final Uint8List image;
  final String email;
  final int emotion;

  const DiaryDetailPage({
    super.key,
    this.id,
    required this.email,
    required this.title,
    required this.content,
    required this.image,
    required this.emotion,
  });

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  int _selectedIndex = 0;

  Future<void> uploadDiary(String email, String title, String content,
      Uint8List imageBytes, String nowDate, Color color, int emotion) async {
    final apiUrl = 'http://localhost:3000/diary/upload'; // 업로드 URL

    // 요청 데이터 생성
    String base64Image = base64Encode(imageBytes);
    String hexColor = '#${color.value.toRadixString(16).substring(2)}';

    Map<String, dynamic> body = {
      'email': email,
      'title': title,
      'diary': content,
      'image': base64Image,
      'createdAt': nowDate,
      'color': hexColor,
      'emotion': emotion,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        print('Diary uploaded successfully');
        Navigator.pop(context);
      } else {
        print('Failed to upload diary: ${response.body}');
      }
    } catch (e) {
      print('Error uploading diary: $e');
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
        print('Diary updated successfully');
        final updatedEntry = DiaryEntry.fromJson(jsonDecode(response.body));
        Navigator.pop(context, updatedEntry); // 수정된 데이터 반환
      } else {
        print('Failed to update diary: ${response.body}');
      }
    } catch (e) {
      print('Error updating diary: $e');
    }
  }

  Future<void> saveOrUpdateDiary(String email, String title, String content,
      Uint8List? imageBytes, int emotion,
      {required String nowDate, required Color color}) async {
    if (widget.id == null && imageBytes != null) {
      // 업로드
      await uploadDiary(
          email, title, content, imageBytes, nowDate, color, emotion);
    } else if (widget.id != null) {
      // 수정
      await updateDiary(email, widget.id!, color);
    } else {
      print('Invalid operation: Either id or imageBytes must be provided.');
    }
  }

  // 상태로 관리될 컨테이너 색상
  String nowdate = DateFormat('yyyy.MM.dd').format(DateTime.now());
  Color _containerColor = const Color(0xffF5DE99);
  bool isFront = true; // true면 이미지가 보이고, false면 빈 화면이 보임

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
                          "컬러",
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
                            await saveOrUpdateDiary(
                              widget.email,
                              widget.title,
                              widget.content,
                              widget.image,
                              nowDate: nowdate,
                              color: _containerColor,
                              widget.emotion,
                            );
                            setState(() {
                              ViewDiary(widget.email);
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewAllDiaryPage(),
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
                        child: const Text(
                          '완료',
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

class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final String image;
  final String createdAt;
  final String color;
  final int emotion;

  DiaryEntry(
      {required this.id,
      required this.title,
      required this.content,
      required this.image,
      required this.createdAt,
      required this.color,
      required this.emotion});

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['_id'] ?? '',
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
  String apiUrl = 'http://localhost:3000/diary/get/test@example.com';
  try {
    final response = await http.get(headers: {
      'Content-Type': 'application/json',
    }, Uri.parse(apiUrl));

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
    print('Error: $e');
    rethrow;
  }
}

class ViewAllDiaryPage extends StatefulWidget {
  const ViewAllDiaryPage({super.key});

  @override
  _ViewAllDiaryPageState createState() => _ViewAllDiaryPageState();
}

class _ViewAllDiaryPageState extends State<ViewAllDiaryPage> {
  @override
  void initState() {
    super.initState();
    futureDiaries = ViewDiary('test@example.com');
  }

  void refreshDiaries() {
    setState(() {
      futureDiaries = ViewDiary('test@example.com');
    });
  }

  late Future<List<DiaryEntry>> futureDiaries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        title: const Text('감정 갤러리'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
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
                              final updatedEntry = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiaryDetailPage(
                                      id: entry.id,
                                      email: 'test@example.com',
                                      title: entry.title,
                                      content: entry.content,
                                      image: base64Decode(entry.image),
                                      emotion: entry.emotion,
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
                      builder: (context) => EmotionPage(),
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
    );
  }
}
