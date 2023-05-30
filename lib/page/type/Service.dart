import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:pltu/services/api_services.dart';

class Service {
  Future<http.Response> addImage(File imageFile) async {
    String addImageUrl = "https://digitm.isoae.com/api/type";

    final headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${APIService.token}",
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse(addImageUrl));
      var multipartFile = await http.MultipartFile.fromPath(
        'images',
        imageFile.path,
        filename: 'image.jpg',
      );

      request.headers.addAll(headers);
      request.files.add(multipartFile);

      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      print('Response status code: ${response.statusCode}');
      print('Response body: $responseString');

      return http.Response(responseString, response.statusCode);
    } catch (e) {
      print('Error: $e');
      rethrow; // Throw the error to be handled by the caller
    }
  }
}
