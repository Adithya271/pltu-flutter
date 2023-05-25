import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pltu/model/login_respon/login_respon.dart';

class APIService {
  static const String baseUrl = 'https://digitm.isoae.com/api';
  static String token = "";

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

    final responseData = LoginRespon.fromJson(jsonDecode(response.body));
    print('respon:$response.body');

    print('Response Body: ${response.body}');
    print('Response Status Code: ${response.statusCode}');
   

    if (response.statusCode == 200) {
      // Login successful
      token = responseData.data!.token!.accessToken!;
      return {'success': true, 'token': token};
    } else {
      // Login failed
      final errorMessage = responseData.responStatus!.message;

      return {'success': false, 'message': errorMessage};
    }
  }
}
