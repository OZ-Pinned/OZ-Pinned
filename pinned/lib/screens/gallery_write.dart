import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Uint8List? _pickedImage;

// 다이어리 업로드 함수
  Future<void> uploadDiary(
      String email, String title, String content, Uint8List? imageBytes) async {
    String apiUrl = 'http://localhost:3000/diary/upload';
    String base64Image = imageBytes != null ? base64Encode(imageBytes) : '';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
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
                  if (_pickedImage != null) {
                    uploadDiary('test@example.com', _titleController.text,
                        _contentController.text, _pickedImage);
                  } else {
                    print("No image selected");
                  }
                  print(widget.emotion);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiaryDetailPage(
                              title: _titleController.text,
                              content: _contentController.text,
                              image: _pickedImage!,
                            )),
                  );
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

class DiaryDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final Uint8List image;

  const DiaryDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.image,
  });

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
            InkWell(
              child: Container(
                height: 380,
                width: 280,
                decoration: BoxDecoration(
                  color: Color(0xffF5DE99),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Image.memory(image, fit: BoxFit.cover),
                    SizedBox(height: 10),
                    Text(title,
                        style: TextStyle(
                          fontFamily: 'LeeSeoYun',
                          fontSize: 28,
                          color: Colors.black,
                        )),
                    Text('2024.12.20',
                        style: TextStyle(
                          fontFamily: 'LeeSeoYun',
                          fontSize: 20,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              onTap: () {},
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.fromLTRB(28, 0, 0, 0),
              height: 230,
              width: double.infinity,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        MaterialButton(
                          height: 52,
                          onPressed: () {},
                          color: Color(0xffFFFFFF),
                          shape: const CircleBorder(),
                        ),
                        MaterialButton(
                          height: 50,
                          onPressed: () {},
                          color: Color(0xff555555),
                          shape: const CircleBorder(),
                        ),
                        MaterialButton(
                          height: 50,
                          onPressed: () {},
                          color: Color(0xffF0B8B2),
                          shape: const CircleBorder(),
                        ),
                        MaterialButton(
                          height: 50,
                          onPressed: () {},
                          color: Color(0xffF5DE99),
                          shape: const CircleBorder(),
                        ),
                        MaterialButton(
                          height: 50,
                          onPressed: () {},
                          color: Color(0xffA898C6),
                          shape: const CircleBorder(),
                        ),
                        MaterialButton(
                          height: 50,
                          onPressed: () {},
                          color: Color(0xff9FA9A1),
                          shape: const CircleBorder(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 47),
                  SizedBox(
                    width: 320, // 버튼 너비
                    height: 52, // 버튼 높이
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFF516A), // 버튼 배경색
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(7)), // 테두리
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
