import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
   static Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? params}) async {
    final url = Uri.parse(endpoint);
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    return json.decode(response.body);
  }

 static Future<dynamic> post(
      String endpoint, dynamic data, Map<String, String> headers) async {
    final response = await http.post(Uri.parse(endpoint),
        headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, dynamic>? params}) async {
    final url = Uri.parse(endpoint);
    final response = await http.put(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, dynamic>? params}) async {
    final url = Uri.parse(endpoint);
    final response = await http.delete(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params));
    return json.decode(response.body);
  }
}
