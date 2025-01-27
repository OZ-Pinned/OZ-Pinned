import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'diaryDetailPage.dart';

class WriteGalleryPage extends StatefulWidget {
  final int emotion;
  final String email;
  const WriteGalleryPage(
      {super.key, required this.email, required this.emotion});
  @override
  State<WriteGalleryPage> createState() => _WriteGalleryPageState();
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
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
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
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Color(0xffF4F4F4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                // color: Color(0x0fffffff),
                alignment: Alignment.center,
                child: _pickedImage == null
                    ? const Icon(Icons.add_a_photo, size: 30)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10), // 모서리 둥글게 처리
                        child: Image.memory(
                          _pickedImage!,
                          width: double.infinity, // 이미지의 너비를 꽉 채우도록 설정
                          height: 200, // 부모 높이와 맞춤
                          fit: BoxFit.cover, // 이미지를 부모 영역에 맞게 크기 조정
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontFamily: 'LeeSeoYun',
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF4F4F4),
                hintText: tr("gallery_title_hintText"),
                labelStyle: TextStyle(
                  fontFamily: 'LeeSeoYun', // 폰트 패밀리 설정
                  color: Color(0xff888888), // 라벨 색상
                  fontSize: 18, // 라벨 글자 크기
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xffDADADA), // 외부 테두리 색상
                    width: 0, // 외부 테두리 두께
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xffFF516A), // 포커스 시 동일한 색상 유지
                    width: 0, // 외부 테두리 두께
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xffDADADA), // 기본 테두리 투명
                    width: 0, // 두께 0
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              style: TextStyle(
                fontFamily: 'LeeSeoYun',
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF4F4F4),
                hintText: tr("gallery_diary_hintText"),
                labelStyle: TextStyle(
                  fontFamily: 'LeeSeoYun', // 폰트 패밀리 설정
                  color: Color(0xff888888), // 라벨 색상
                  fontSize: 18, // 라벨 글자 크기
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xffDADADA), // 외부 테두리 색상
                    width: 0, // 외부 테두리 두께
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xffFF516A), // 포커스 시 동일한 색상 유지
                    width: 0, // 외부 테두리 두께
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xffDADADA), // 기본 테두리 투명
                    width: 0, // 두께 0
                  ),
                ),
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
                          color: "#E9E9E9",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(tr("gallery_snackbar"))),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFF516A), // 버튼 배경색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)), // 테두리
                  ),
                ),
                child: Text(
                  tr("next"),
                  style: TextStyle(
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
