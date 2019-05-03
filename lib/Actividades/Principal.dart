import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prueba/Actividades/LogIn.dart';
import 'package:prueba/Adaptadores/user_info.dart';
import 'package:prueba/Herramientas/Strings.dart';
import 'package:prueba/Herramientas/appColors.dart';
import 'package:prueba/Herramientas/navigation_bar.dart';
import 'package:prueba/TDA/Persona.dart';

class Principal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _Principal();
  }
}

class _Principal extends State<Principal> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String nombre = "", foto = "";

  Future initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((user) {
      if (user == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LogIn()),
            ModalRoute.withName('/logIn'));
      }
      else{
        setState(() {
          nombre = user.displayName;
          foto = user.photoUrl;
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("assets/images/fondo.png"),
                fit: BoxFit.none,
                repeat: ImageRepeat.repeat),
          ),
        ),
        UserInfoM(new Persona(nombre, foto)),
        NavigationBar(false),
        Padding(
          padding: Platform.isAndroid
              ? EdgeInsets.only(left: 20, top: 40, right: 10)
              : EdgeInsets.only(left: 20, top: 50, right: 10),
          child: Text(
            Strings.semanalince,
            style: TextStyle(
                color: AppColors.colorAccent,
                fontSize: 30.0,
                fontFamily: "GoogleSans",
                fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

}
