import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WriteGalleryPage(
        emotion: 2,
      ),
    );
  }
}

class WriteGalleryPage extends StatefulWidget {
  final int emotion;
  const WriteGalleryPage({super.key, required this.emotion});

  @override
  State<WriteGalleryPage> createState() => _WriteGalleryPageState();
}

class _WriteGalleryPageState extends State<WriteGalleryPage> {
  final String email = "test@example.com";
  // 다이어리 DB에 업로드
  Future<void> uploadDiary(
      String title, String content, Uint8List? imageBytes) async {
    final apiUrl = 'http://localhost:3000/diary/upload';
    String base64Image = imageBytes != null ? base64Encode(imageBytes) : '';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email, // 클래스 레벨 변수 사용
          'title': title,
          'diary': content,
          'image': base64Image,
        }),
      );

      if (response.statusCode == 201) {
        print('Diary uploaded successfully');
      } else {
        print('Failed to upload diary: ${response.body}');
      }
    } catch (e) {
      print('Error uploading diary: $e');
    }
  }

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
    String email = "test@example.com";
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
                                title: _titleController.text,
                                content: _contentController.text,
                                image: _pickedImage!,
                                email: email,
                              )),
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
  final String title;
  final String content;
  final Uint8List image;
  final String email;

  const DiaryDetailPage({
    Key? key,
    required this.email,
    required this.title,
    required this.content,
    required this.image,
  }) : super(key: key);

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  Color _containerColor = Color(0xffF5DE99); // 상태로 관리될 컨테이너 색상
  String nowdate = DateFormat('yyyy.MM.dd').format(DateTime.now());

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
        title: const Text('감정 꾸미기'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            GestureDetector(
              onTap: _flipCard,
              child: Container(
                height: 380,
                width: 280,
                decoration: BoxDecoration(
                  color: _containerColor, // 컨테이너 색상 지정
                ),
                child: isFront
                    ? Column(
                        children: [
                          SizedBox(height: 20),
                          Image.memory(widget.image, fit: BoxFit.cover),
                          SizedBox(height: 10),
                          Text(widget.title,
                              style: TextStyle(
                                fontFamily: 'LeeSeoYun',
                                fontSize: 28,
                                color: Colors.black,
                              )),
                          Text(nowdate,
                              style: TextStyle(
                                fontFamily: 'LeeSeoYun',
                                fontSize: 20,
                                color: Color(0xff888888),
                              )),
                        ],
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
            ),
            SizedBox(height: 10),
            Spacer(),
            Container(
              height: 230,
              width: double.infinity,
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(color: Color(0xffFFFFFF)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
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
                        children: List.generate(6, (index) {
                          final List<Color> colors = [
                            Color(0xffFFFFFF),
                            Color(0xff555555),
                            Color(0xffF0B8B2),
                            Color(0xffF5DE99),
                            Color(0xffA898C6),
                            Color(0xff9FA9A1),
                          ];
                          return MaterialButton(
                            height: 50,
                            onPressed: () {
                              setState(() {
                                _containerColor = colors[index];
                              });
                            },
                            color: colors[index],
                            shape: const CircleBorder(),
                          );
                        }),
                      ),
                    ),
                  ),
                  SizedBox(height: 47),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewAllDiaryPage()),
                          );
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
  final String title;
  final String content;
  final String image;

  DiaryEntry({required this.title, required this.content, required this.image});

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      title: json['title'] ?? 'Untitled',
      content: json['diary'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

Future<List<DiaryEntry>> fetchDiaries(String email) async {
  String apiUrl = 'http://localhost:3000/diary/get/test@example.com';
  try {
    final response = await http.get(headers: {
      'Content-Type': 'application/json',
    }, Uri.parse(apiUrl));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

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
  @override
  _ViewAllDiaryPageState createState() => _ViewAllDiaryPageState();
}

class _ViewAllDiaryPageState extends State<ViewAllDiaryPage> {
  @override
  void initState() {
    super.initState();
    futureDiaries = fetchDiaries('test@example.com');
  }

  late Future<List<DiaryEntry>> futureDiaries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('감정 갤러리'),
      ),
      body: FutureBuilder<List<DiaryEntry>>(
        future: futureDiaries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DiaryEntry entry = snapshot.data![index];
                return Card(
                  child: Column(
                    children: <Widget>[
                      Image.memory(
                        base64Decode(entry.image),
                        fit: BoxFit.cover,
                      ),
                      ListTile(
                        title: Text(entry.title),
                        subtitle: Text(entry.content),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
