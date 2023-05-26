import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0), //SET MARGIN DARI CONTAINER
      child: Form(
        child: Column(
          //CHILDREN DARI COLUMN BERISI 4 BUAH OBJECT YANG AKAN DI-RENDER, YAKNI
          // TextInput UNTUK NAME, EMAIL, PASSWORD DAN TOMBOL DAFTAR
          children: [
            nameField(),
            emailField(),
            passwordField(),
            logoutbutton(),
          ]
          
        )
      ),
    );
  }

  Widget nameField() {
    //MEMBUAT TEXT INPUT
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nama Lengkap' //DENGAN LABEL Nama Lengkap
      ),
      //AKAN BERISI VALIDATION
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress, // KEYBOARD TYPENYA ADALAH EMAIL ADDRESS
      //AGAR SYMBOL @ DILETAKKAN DIDEPAN KETIKA KEYBOARD DI TAMPILKAN
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'email@example.com',
      ),
      //AKAN BERISI VALIDATION
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true, //KETIKA obsecureText bernilai TRUE
      //MAKA SAMA DENGAN TYPE PASSWORD PADA HTML
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter Password',
      ),//AKAN BERISI VALIDATION
    );
  }
  Widget logoutbutton(){
   return SizedBox(
    width: 200,
    height: 30,
     child: ElevatedButton(
     onPressed: () {
        print('ini done');
     },
     child: new Text('Logout'),
     ),
   );
  }
  }