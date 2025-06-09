import 'package:http/http.dart' as http;
import 'dart:convert';

class Testapi {
  static Future<http.Response?> saveTestScore(String email, int score) async {
    try {
      final response = await http.post(
        Uri.parse('http://13.209.69.93:3000/test/save'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'score': score,
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
