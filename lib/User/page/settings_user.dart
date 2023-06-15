import 'package:flutter/material.dart';
import 'package:pltu/signup_login/sign_in.dart';

class SettingsUser extends StatelessWidget {
  const SettingsUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0, // Koordinat Y dari bagian atas
          left: 0, // Koordinat X dari bagian kiri
          child: ClipPath(
            clipper: ShapeClipper(),
            child: Container(
              width: 400, //
              height: 250,
              color: Colors.blue,
              child: Center(
                child: Image.asset(
                  'assets/grup1.png',
                  width: 200,
                  height: 190,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10, // Koordinat Y dari bagian atas
          right: 15, // Koordinat X dari bagian kanan
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              );
            },
            child: Image.asset(
              'assets/logopltu.png', // Ganti dengan path gambar logo PLTU Anda
              width: 30,
              height: 30,
            ),
          ),
        ),
        Positioned(
          top: 210, // Koordinat Y dari bagian atas
          left: 100, // Koordinat X dari bagian kiri
          child: Image.asset('assets/isoae.png'),
        ),
        Positioned(
          top: 280, // Koordinat Y dari bagian atas
          left: 35, // Koordinat X dari bagian kiri
          child: SizedBox(
            width: 300,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const [
                  TextSpan(
                    text: 'PT.ASLI ISOAE SOLUSINE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 308, // Koordinat Y dari bagian atas
          left: 40, // Koordinat X dari bagian kiri
          child: SizedBox(
            width: 300,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const [
                  TextSpan(
                    text:
                        'Kami mengubah permintaan klien tentang desain & pengembangan web menjadi karya nyata. Dikemas dengan pengalaman 10 tahun dalam mengembangkan situs web,',
                  ),
                  TextSpan(
                    text:
                        ' kami tahu cara membuat situs web canggih yang melibatkan pengunjung Anda dan mengonversi.',
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 470, // Koordinat Y dari bagian atas
          left: 40, // Koordinat X dari bagian kiri
          child: SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const [
                      TextSpan(
                        text: 'Website',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    height: 1), // Jarak antara teks "Website" dan teks URL
                Text(
                  'https://isoae.id/',
                  style: DefaultTextStyle.of(context).style,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 308, // Koordinat Y dari bagian atas
          left: 40, // Koordinat X dari bagian kiri
          child: SizedBox(
            width: 300,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const [
                  TextSpan(
                    text:
                        'Kami mengubah permintaan klien tentang desain & pengembangan web menjadi karya nyata. Dikemas dengan pengalaman 10 tahun dalam mengembangkan situs web,',
                  ),
                  TextSpan(
                    text:
                        ' kami tahu cara membuat situs web canggih yang melibatkan pengunjung Anda dan mengonversi.',
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 515, // Koordinat Y dari bagian atas
          left: 40, // Koordinat X dari bagian kiri
          child: SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const [
                      TextSpan(
                        text: 'Telepon',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    height: 1), // Jarak antara teks "Website" dan teks URL
                Text(
                  '021-75923000',
                  style: DefaultTextStyle.of(context).style,
                ),
              ],
            ),
          ),
        ),
        // Tambahkan widget lainnya di bawah atau di atas gambar dan teks
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
