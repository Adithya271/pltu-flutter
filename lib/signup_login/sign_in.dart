import 'package:flutter/material.dart';
import 'package:pltu/page/home.dart';
import 'package:pltu/services/api_services.dart';
import 'package:email_validator/email_validator.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

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
              const Text(
                'Login Admin',
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
            ],
          ),
        ),
      ),
    );
  }
}
