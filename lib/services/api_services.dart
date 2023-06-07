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
    print('Response Body: ${response.body}');
    print('Response Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Login successful
      token = responseData.data!.token!.accessToken!;
      final userId = responseData.data!.record!.id;
      return {'success': true, 'token': token, 'userId': userId};
    } else {
      // Login failed
      final errorMessage = responseData.responStatus!.message;

      return {'success': false, 'message': errorMessage};
    }
  }

  //signup
  static Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    final apiUrl = Uri.parse('$baseUrl/register');

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    print('Response Body: ${response.body}');
    print('Response Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      try {
        final responseData = jsonDecode(response.body);
        final userId = responseData['id'];
        return {'success': true};
      } catch (e) {
        print('Error parsing JSON: $e');
        return {'success': false, 'message': 'Error parsing JSON'};
      }
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  //logout
  static Future<void> logout() async {
    final apiUrl = Uri.parse('$baseUrl/logout');

    final response = await http.get(
      apiUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Logout successful
      token = '';
      print('Logout successful');
    } else {
      // Logout failed
      print('Logout failed');
    }
  }

  //mengambil data user
  
}
