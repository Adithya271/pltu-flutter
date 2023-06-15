import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 10), // Mengatur jarak atas
        child: SizedBox(
          height: 100,
          width: 250.0,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 15.0,
              fontFamily: 'Agne',
              color: Colors.blue, // Mengatur warna teks default
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Tetap selalu optimis',
                  textStyle: TextStyle(color: Colors.red), // Mengubah warna teks
                ),
                TypewriterAnimatedText(
                  'Jangan pantang menyerah',
                  textStyle: TextStyle(color: Colors.green), // Mengubah warna teks
                ),
                TypewriterAnimatedText(
                  'Jangan putus asa',
                  textStyle: TextStyle(color: Colors.orange), // Mengubah warna teks
                ),
                TypewriterAnimatedText(
                  'Kita Bisa !!!',
                  textStyle: TextStyle(color: Colors.purple), // Mengubah warna teks
                ),
              ],
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
        ),
      ),
    );
  }

}

