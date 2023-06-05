import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pltu/page/home.dart';
import 'package:pltu/signup_login/sign_in.dart';

import '../services/api_services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleIdController = TextEditingController();

  String _emailErrorText = '';
  String _passwordErrorText = '';
  String _nameErrorText = '';
  String _roleIdErrorText = '';

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final roleId = int.tryParse(_roleIdController.text) ?? 0;

    setState(() {
      _emailErrorText = '';
      _passwordErrorText = '';
      _nameErrorText = '';
      _roleIdErrorText = '';
    });

    if (email.isEmpty) {
      setState(() {
        _emailErrorText = 'Email must be filled';
      });
      return;
    }

    if (!EmailValidator.validate(email)) {
      setState(() {
        _emailErrorText = 'Invalid email format';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordErrorText = 'Password must be filled';
      });
      return;
    }

    if (name.isEmpty) {
      setState(() {
        _nameErrorText = 'Name must be filled';
      });
      return;
    }

    if (roleId == null) {
      setState(() {
        _roleIdErrorText = 'Invalid role ID';
      });
      return;
    }

    // Check if the user is logged in
    if (APIService.token.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please log in before registering.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              },
            ),
          ],
        ),
      );
      return;
    }

    final registerResult =
        await APIService.register(email, password, name, roleId);

    try {
      if (registerResult['success']) {
        // Registration successful

        // Print record data
        print('Register Result:[success] $registerResult');

        // Show success pop-up for 2 seconds
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // TODO: Handle successful registration
      } else {
        // Registration failed
        final errorMessage = registerResult['message'] ?? 'Registration failed';
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Registration Failed'),
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
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
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
                    errorText: _passwordErrorText.isNotEmpty
                        ? _passwordErrorText
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: const OutlineInputBorder(),
                    errorText:
                        _nameErrorText.isNotEmpty ? _nameErrorText : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _roleIdController,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: const OutlineInputBorder(),
                    errorText:
                        _roleIdErrorText.isNotEmpty ? _roleIdErrorText : null,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Background color
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
