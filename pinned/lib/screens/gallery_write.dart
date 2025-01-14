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
      home: const WriteGalleryPage(),
    );
  }
}

class WriteGalleryPage extends StatefulWidget {
  const WriteGalleryPage({super.key});

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
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

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
      backgroundColor: Color(0xffFFFFFF),
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
                color: Color(0xffF4F4F4),
                child: _pickedImage == null
                    ? const Icon(Icons.add_a_photo, size: 30)
                    : Image.memory(_pickedImage!, fit: BoxFit.cover),
                alignment: Alignment.center,
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
