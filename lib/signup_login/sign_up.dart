import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
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

  String _emailErrorText = '';
  String _passwordErrorText = '';
  String _nameErrorText = '';

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;

    setState(() {
      _emailErrorText = '';
      _passwordErrorText = '';
      _nameErrorText = '';
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
        await APIService.register(email, password, name);

    try {
      if (registerResult['success']) {
        // Registration successful

        // Print record data
        print('Register Result:[success] $registerResult');

        // Show success pop-up for 2 seconds
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Akun berhasil dibuat,silahkan cek email untuk verifikasi'),
            duration: Duration(seconds: 4),
          ),
        );

        // Clear the form fields
        _emailController.clear();
        _passwordController.clear();
        _nameController.clear();

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
    backgroundColor: Colors.blue[200],
    resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                       Positioned(
                          top: 20, // Atur posisi vertikal gambar sesuai keinginan
                          child: Image.asset(
                            'assets/txtsignup.png',
                            height: 100,
                            alignment: Alignment.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15), // Ubah nilai sesuai dengan ukuran border radius yang diinginkan
                          ),
                              errorText: _emailErrorText.isNotEmpty ? _emailErrorText : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15), // Ubah nilai sesuai dengan ukuran border radius yang diinginkan
                          ),
                              errorText: _passwordErrorText.isNotEmpty ? _passwordErrorText : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15), // Ubah nilai sesuai dengan ukuran border radius yang diinginkan
                          ),
                              errorText: _nameErrorText.isNotEmpty ? _nameErrorText : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _register,
                            child: const Text('Sign Up'),
                            style: ElevatedButton.styleFrom(
                            minimumSize: Size(220, 50),
                          ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 70),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignIn()),
                                );
                              },
                              child: Row(
                                children: const [
                                  Text("Sudah punya akun? "),
                                  Text(
                                    "Login disini !",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600
                                      
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
      ],
    ),
  );
}
}