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
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 10), // Mengatur jarak atas
        child: SizedBox(
          height: 100,
          width: 250.0,
         
              child: Text('Selamat Datang '),
        ),
      ),
    );
  }
}
