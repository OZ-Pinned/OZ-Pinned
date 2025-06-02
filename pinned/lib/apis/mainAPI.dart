import 'package:http/http.dart' as http;
import 'dart:convert';

class Mainapi {
  static Future<http.Response?> signup(
      String email, int character, String name) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://13.209.69.93:3000/user/signup'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'name': name,
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

  static Future<http.Response?> sendEmail(String email) async {
    print(email);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/user/login'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      print(response);

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<http.Response?> login(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/user/login'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': email}),
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
