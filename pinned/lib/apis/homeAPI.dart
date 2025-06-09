import 'package:http/http.dart' as http;

class Homeapi {
  static Future<http.Response?> getUser(String email) async {
    try {
      final response = await http.get(
        Uri.parse('13.209.69.93:3000/home/get/$email'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
