import 'package:flutter/material.dart';
import 'package:pltu/User/page/home_user.dart';
import 'package:pltu/User/signup_login/sign_up_user.dart';
import 'package:pltu/User/services/api_services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pltu/signup_login/sign_in.dart';

class SignInUser extends StatefulWidget {
  const SignInUser({super.key});

  @override
  _SignInUserState createState() => _SignInUserState();
}

class _SignInUserState extends State<SignInUser> {
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
        if (loginResult['userId'] == 4) {
          // UserId is 4, login success
          // Print record data
          print('Login Result:[success] $loginResult');

          // Navigate to the HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePageUser()),
          );
        } else {
          // UserId is not 4, login failed
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Login Failed'),
              content: const Text('You are not a user.'),
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
        final errorMessage =
            loginResult['message'] ?? 'Email atau password salah';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 270),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                  child: Row(
                    children: const [
                      Text(
                        "Anda Admin? ",
                      ),
                      Text(
                        "Login sebagai Admin",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                'Login User',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
                  errorText:
                      _passwordErrorText.isNotEmpty ? _passwordErrorText : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpUser()),
                    );
                  },
                  child: Row(
                    children: const [
                      Text(
                        "Belum punya akun? ",
                      ),
                      Text(
                        "Buat akun disini",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
