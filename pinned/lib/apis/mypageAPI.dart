import 'package:http/http.dart' as http;
import 'dart:convert';

class Mypageapi {
  static Future<http.Response?> getTest(String email) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/mypage/get/$email'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<http.Response?> changeCharacter(
      String email, int character) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/mypage/change/$email'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'character': character,
        }),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
