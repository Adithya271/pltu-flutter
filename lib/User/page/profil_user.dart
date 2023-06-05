import 'package:flutter/material.dart';
import 'package:pltu/services/api_services.dart';
import 'package:pltu/signup_login/sign_in.dart';
import 'package:pltu/signup_login/sign_up.dart';

class ProfilPageUser extends StatefulWidget {
  const ProfilPageUser({Key? key}) : super(key: key);

  @override
  State<ProfilPageUser> createState() => _ProfilPageStateUser();
}

class _ProfilPageStateUser extends State<ProfilPageUser> {
  Future<void> _logout() async {
    final confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true when "Yes" is pressed
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false when "No" is pressed
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      await APIService.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Page'),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
            
          ],
        ),
      ),
    );
  }
}
