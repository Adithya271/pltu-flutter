import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = 'https://digitm.isoae.com/api';

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final apiUrl = Uri.parse('$baseUrl/login');

    final response = await http.post(
      apiUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);

    print('Response Body: ${response.body}');
    print('Response Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Login successful
      return {'success': true, 'token': responseData['token']};
    } else {
      // Login failed
      return {'success': false, 'message': responseData['message']};
    }
  }
}
