import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pltu/page/profil.dart';
import 'package:pltu/services/api_services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pltu/signup_login/sign_up.dart';

import '../User/page/home_user.dart';
import '../User/page/settings_user.dart';
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
        // Login successful
        if (loginResult['userId'] == 1) {
          // UserId is 1, login success
          // Print record data
          print('Login Result:[success] $loginResult');

          // Navigate to the HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
      // UserId is not 1, login failed
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Anda bukan Admin'),
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
  } else {
    // Login failed
    final errorMessage = loginResult['message'] ?? 'Email atau password salah';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(errorMessage),
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
 on FormatException {
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
        MaterialPageRoute(builder: (context) => const HomePageUser()),
      );
    }
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/txtlogin.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorText:
                        _emailErrorText.isNotEmpty ? _emailErrorText : null,
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
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 180,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(220, 50),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text: 'Buat akun? ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Disini !',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
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
              decoration: BoxDecoration(
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
