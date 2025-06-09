import 'dart:io';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'diaryDetailPage.dart';

class WriteGalleryPage extends StatefulWidget {
  final int emotion;
  final String email;
  const WriteGalleryPage(
      {super.key, required this.email, required this.emotion});

  @override
  State<WriteGalleryPage> createState() => _WriteGalleryPageState();
}

class _WriteGalleryPageState extends State<WriteGalleryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  File? _selectedImage; // 선택한 이미지 저장
  bool _isUploading = false; // 업로드 중 상태 관리

  // 📌 이미지 선택
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // 📌 이미지 S3 업로드
  Future<String?> uploadImageToS3(File imageFile) async {
    final apiUrl =
        'http://13.209.69.93:3000/diary/upload-image'; // S3 업로드 API 엔드포인트
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Content-Type'] = 'multipart/form-data'; // 이 헤더 추가

    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['imageUrl']; // S3에서 반환된 이미지 URL
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // 📌 저장 버튼 눌렀을 때 실행
  // 📌 저장 버튼 눌렀을 때 실행
  Future<void> saveDiary() async {
    if (_selectedImage == null ||
        _titleController.text.isEmpty ||
        _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr("gallery_snackbar"))),
      );
      return;
    }

    setState(() {
      _isUploading = true; // 업로드 중 상태 변경
    });

    // 1️⃣ S3에 이미지 업로드
    String? imageUrl = await uploadImageToS3(_selectedImage!);

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이미지 업로드 실패")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    // 2️⃣ S3 URL과 함께 diaryDetailPage로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryDetailPage(
          id: null,
          title: _titleController.text,
          content: _contentController.text,
          image: imageUrl, // S3에서 받은 이미지 URL 전달
          email: widget.email,
          emotion: widget.emotion,
          color: "#E9E9E9",
        ),
      ),
    );

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFFFF),
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
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffF4F4F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: _selectedImage == null
                    ? const Icon(Icons.add_a_photo, size: 30)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF4F4F4),
                hintText: tr("gallery_title_hintText"),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xffDADADA), width: 0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF4F4F4),
                hintText: tr("gallery_diary_hintText"),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xffDADADA), width: 0),
                ),
              ),
            ),
            const SizedBox(height: 130),
            SizedBox(
              width: 320,
              height: 52,
              child: ElevatedButton(
                onPressed: _isUploading ? null : saveDiary, // 업로드 중이면 버튼 비활성화
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF516A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(
                        color: Colors.white) // 업로드 중 표시
                    : Text(
                        tr("next"),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
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
