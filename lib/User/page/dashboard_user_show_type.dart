import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DashboardUserShowType extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String content;

  const DashboardUserShowType({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Html(
              data: content,
              style: {
                'p': Style(fontSize: const FontSize(16.0)),
                'img': Style(
                  width: double.infinity,
                  height: double.infinity,
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                ),
                'iframe': Style(
                  width: double.infinity,
                  height: 200.0,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
