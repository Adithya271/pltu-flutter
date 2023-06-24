import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';

class ShowContent extends StatelessWidget {
  final String nama;
  final String content;

  const ShowContent({required this.nama, required this.content, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nama),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        // child: Html(
        //   data: content,
        //   style: {
        //     'p': Style(fontSize: const FontSize(16.0)),
        //     'img': Style(
        //       width: double.infinity,
        //       height: double.infinity,
        //       margin: const EdgeInsets.all(0),
        //       padding: const EdgeInsets.all(0),
        //     ),
        //     'iframe': Style(
        //       width: double.infinity,
        //       height: 200.0,
        //     ),
        //   },
        // ),
      ),
    );
  }
}
