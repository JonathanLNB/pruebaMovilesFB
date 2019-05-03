import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prueba/Actividades/LogIn.dart';
import 'package:prueba/Herramientas/appColors.dart';
import 'package:prueba/TDA/Persona.dart';

class UserInfoM extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Persona persona;
  UserInfoM(this.persona);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return headerInfo(context);
  }

  Container headerInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100.0),
      height: 250.0,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 20.0, right: 20.0, bottom: 10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    persona.nombre,
                    style: TextStyle(
                      color: AppColors.verdeColor,
                      fontSize: 20.0,
                      fontFamily: "GoogleSans",
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Stack(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                cerrarSesion(context);
                              },
                              child: Container(
                                height: 44,
                                width: 44,
                                margin: EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/signout.png")),
                                ),
                              ),
                            )
                          ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: persona.foto.length > 0
                        ? new NetworkImage(persona.foto)
                        : NetworkImage('http://i.pravatar.cc/300')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void cerrarSesion(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset('assets/images/sad.gif', fit: BoxFit.cover),
              title: Text(
                'Confirmación 😱',
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: "GoogleSans",
                    fontWeight: FontWeight.bold,
                    color: AppColors.verdeDarkLightColor),
              ),
              description: Text(
                '¿${persona.nombre.split(" ")[2]} estás segur@ de cerrar tu sesión ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "GoogleSans",
                    color: AppColors.azulMarino),
              ),
              buttonCancelText: Text(
                "Cancelar",
                style: TextStyle(fontFamily: "GoogleSans", color: Colors.white),
              ),
              buttonOkText: Text(
                "Aceptar",
                style: TextStyle(fontFamily: "GoogleSans", color: Colors.white),
              ),
              onOkButtonPressed: () {
                _googleSignIn.signOut();
                _auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                    ModalRoute.withName('/logIn'));
              },
            ));
  }
}
