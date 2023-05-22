import 'package:flutter/material.dart';
import 'package:pltu/page/area/BrowseArea.dart';
import 'package:pltu/page/home.dart';
import 'package:pltu/signup_login/sign_in.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
    home: SignIn(),
      routes: <String, WidgetBuilder>{
        // '/dashboard': (BuildContext context) => new Dashboard(title: title),
        // '/adddata': (BuildContext context) => new AddData(title: title),
        // '/register': (BuildContext context) => new RegisterPage(title: title),
        // '/login': (BuildContext context) => new LoginPage(title: title),
      },
    );
  }
}