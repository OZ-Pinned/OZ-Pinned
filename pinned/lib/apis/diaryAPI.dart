import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

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

class Diaryapi {
  static Future<http.Response?> ViewDiary(String email) async {
    String apiUrl = 'http://192.168.0.65:3000/diary/get/$email';
    try {
      final response = await http.get(headers: {
        'Content-Type': 'application/json',
      }, Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response?> uploadDiary(
      String email,
      String title,
      String content,
      Uint8List imageBytes,
      String nowDate,
      Color color,
      int emotion) async {
    final apiUrl = 'http://192.168.0.65:3000/diary/upload'; // 업로드 URL

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
        return response;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<http.Response?> updateDiary(
      String email, String id, Color color) async {
    final apiUrl = 'http://192.168.0.65:3000/diary/edit'; // 수정 URL

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
        return response;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static String getImagePath(double value) {
    if (value <= 25) {
      return 'assets/images/angryEmotion.svg'; // 슬라이더 값이 0~25일 때
    } else if (value <= 50) {
      return 'assets/images/sadEmotion.svg'; // 슬라이더 값이 26~50일 때
    } else if (value <= 75) {
      return 'assets/images/noneEmotion.svg'; // 슬라이더 값이 51~75일 때
    } else {
      return 'assets/images/happyEmotion.svg'; // 슬라이더 값이 76~100일 때
    }
  }

  static Color getColorCode(double value) {
    if (value <= 25) {
      return Color(0xff96BDFF); // 슬라이더 값이 0~25일 때
    } else if (value <= 50) {
      return Color(0xff59F09F); // 슬라이더 값이 26~50일 때
    } else if (value <= 75) {
      return Color(0xffFFD751); // 슬라이더 값이 51~75일 때
    } else {
      return Color(0xffFFAE51); // 슬라이더 값이 76~100일 때
    }
  }
}
