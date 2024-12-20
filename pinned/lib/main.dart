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
      appBar: AppBar(
        title: const Text("First"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            // 레이아웃을 세로 방향으로 정렬
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Hello",
                style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 24),
              ),
              const SizedBox(height: 20), // 텍스트와 TextField 간 간격 추가
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(), // TextField의 외곽선
                  labelText: 'Enter your name', // 힌트 텍스트
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
