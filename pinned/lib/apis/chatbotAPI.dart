import 'package:http/http.dart' as http;
import 'dart:convert';

class Chatbotapi {
  static Future<http.Response?> handleSubmitted(
      String email, String inputedMessage, String name) async {
    try {
      var response = await http.post(
        Uri.parse("http://localhost:3000/chatbot/get"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'msg': inputedMessage,
            'name': name,
          },
        ),
      );

      print(response.statusCode);

      if (response.statusCode == 201) {
        return response;
      } else {
        return null;
      }
    } catch (error) {
      print('AI error: $error');
    }

    return null;
  }
}
