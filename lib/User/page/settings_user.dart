import 'package:flutter/material.dart';
import 'package:pltu/signup_login/sign_in.dart';

class SettingsUser extends StatelessWidget {
  const SettingsUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: ShapeClipper(),
          child: Container(
            height: 250,
            color: Colors.blue,
            child: Center(
              child: Image.asset(
                'assets/grup1.png', // Ganti dengan path gambar Anda
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(right: 100.0), // Ubah nilai left sesuai kebutuhan
          child: Image.asset(
            'assets/khusus.png', // Ganti dengan path gambar khusus Anda
            width: 200,
            height: 100,
          ),
        ),
        SizedBox(height: 50),
        Container(
          width: 200, // Ubah lebar sesuai kebutuhan
          height: 35, // Ubah tinggi sesuai kebutuhan
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
              );
            },
            child: Text('Login'),
          ),
        ),
        SizedBox(height: 90),
         Positioned(
                    top: 0,
                    child: Image.asset(
                      'assets/grup2.png', // Ganti dengan path gambar grup2 Anda
                      width: 77,
                      height: 14,
                    ),
                  ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10), // Atur jarak vertikal sesuai kebutuhan
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10,), // Atur jarak kanan sesuai kebutuhan
                child: Image.network(
                  'https://th.bing.com/th/id/OIP.d9GZxbX8Gi9_qGg7XP1ntgHaHa?w=218&h=218&c=7&r=0&o=5&pid=1.7', // Ganti dengan URL logo Facebook Anda
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10), // Atur jarak horizontal sesuai kebutuhan
                child: Image.network(
                  'https://th.bing.com/th/id/OIP.tHP8rVlfCbCv4ScNkBasjAHaHa?w=217&h=217&c=7&r=0&o=5&pid=1.7', // Ganti dengan URL logo Instagram Anda
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10), // Atur jarak kiri sesuai kebutuhan
                child: Image.network(
                  'https://th.bing.com/th/id/OIP.P3GJZi8Z-DGPx1JS3u5yOgHaGl?w=216&h=191&c=7&r=0&o=5&pid=1.7', // Ganti dengan URL logo Twitter Anda
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 25);
    path.quadraticBezierTo(
      size.width / 4, // Control point x
      size.height, // Control point y
      size.width / 2, // End point x
      size.height, // End point y
    );
    path.quadraticBezierTo(
      size.width * 3 / 4, // Control point x
      size.height, // Control point y
      size.width, // End point x
      size.height - 25, // End point y
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
