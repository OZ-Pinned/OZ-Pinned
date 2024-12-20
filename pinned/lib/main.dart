import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Input Name',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Input Name'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF9F8),
      appBar: AppBar(
        title: const Text("First"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // 레이아웃을 세로 방향으로 정렬
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "이름을 작성해주세요",
                style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 24),
              ),
              const SizedBox(height: 20), // 텍스트와 TextField 간 간격 추가
              SizedBox(
                width: 320,
                height: 55,
                child: const TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // 내부 배경색 설정
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffDADADA), // 외부 테두리 색상
                        width: 1.0, // 외부 테두리 두께
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffDADADA), // 포커스 시 동일한 색상 유지
                        width: 1.0, // 외부 테두리 두께
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent, // 기본 테두리 투명
                        width: 0, // 두께 0
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 377),
              SizedBox(
                width: 320,
                height: 52,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF516A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                    ),
                    onPressed: () {},
                    child: Text(
                      '다음',
                      style: TextStyle(
                          fontFamily: 'LeeSeoYun',
                          fontSize: 20,
                          color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
