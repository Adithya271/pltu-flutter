import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
   final String nama;
  final String imageUrl;

  const ShowImage({Key? key, required this.nama, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nama),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
