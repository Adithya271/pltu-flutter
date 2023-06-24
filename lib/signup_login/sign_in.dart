import 'package:flutter/material.dart';
import 'package:pltu/services/api_services.dart';
import 'package:email_validator/email_validator.dart';

import '../User/page/home_user.dart';
import '../page/home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _emailErrorText = '';
  String _passwordErrorText = '';

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _emailErrorText = '';
      _passwordErrorText = '';
    });

    if (email.isEmpty) {
      setState(() {
        _emailErrorText = 'Email harus diisi';
      });
      return;
    }

    if (!EmailValidator.validate(email)) {
      setState(() {
        _emailErrorText = 'Email harus valid';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordErrorText = 'Password harus diisi';
      });
      return;
    }

    final loginResult = await APIService.login(email, password);
    print('Login: ${loginResult["success"]}');

    try {
      if (loginResult['success']) {
        // ke HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FormatException {
      // FormatException occurred
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Invalid response received from the server.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {
      // Other exceptions occurred
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An unexpected error occurred.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePageUser()),
                  );
                }),
          ),
          Positioned(
            top: 90,
            left: 120,
            child: Image.asset(
              'assets/txtlogin.png', // Ganti dengan path yang sesuai dengan lokasi file txtlogin.png di dalam folder assets
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 200,
            left: 40,
            right: 40,
            child: SizedBox(
              width: 300, // Atur lebar Card sesuai keinginan
              height: 300, // Atur tinggi Card sesuai keinginan
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/grup3.png', // Ganti dengan path yang sesuai dengan lokasi file gambar email_icon.png di dalam folder assets
                        width: 80,
                        height: 20,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          errorText: _emailErrorText.isNotEmpty
                              ? _emailErrorText
                              : null,
                          prefixIcon: const Icon(
                              Icons.email), // Tambahkan ikon email di sini
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorText: _passwordErrorText.isNotEmpty
                                ? _passwordErrorText
                                : null,
                            prefixIcon: const Icon(Icons.key)),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height:
                            40, // Atur tinggi ElevatedButton sesuai keinginan
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _login(); // Tambahkan fungsi yang akan dijalankan ketika tombol "Login" ditekan
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bgbuild.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        size.width * 0.8, 0, size.width * 0.7, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.3,
        size.width * 0.4, size.height * 0.3);
    path.quadraticBezierTo(
        size.width * 0.2, size.height * 0.3, 0, size.height * 0.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
