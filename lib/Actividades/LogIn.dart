import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prueba/Actividades/Principal.dart';
import 'package:prueba/Herramientas/Strings.dart';
import 'package:prueba/Herramientas/appColors.dart';
import 'package:prueba/Herramientas/navigation_bar.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LogIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LogIn();
  }
}

class _LogIn extends State<LogIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging firebase = new FirebaseMessaging();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _success;
  String _userID, token, email, foto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebase.configure(
      onLaunch: (Map<String, dynamic> msg) {},
      onResume: (Map<String, dynamic> msg) {},
      onMessage: (Map<String, dynamic> msg) {},
    );
    firebase.getToken().then((token) {
      print(token);
    });
    getUser().then((user) {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Principal()),
            ModalRoute.withName('/principal'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(children: <Widget>[
        NavigationBar(true),
        Container(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: Platform.isAndroid
                ? EdgeInsets.only(top: 150)
                : EdgeInsets.only(top: 150),
            child: Text(
              "¡Bienvenido!",
              style: TextStyle(
                  color: AppColors.colorAccent,
                  fontSize: 30.0,
                  fontFamily: "GoogleSans",
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 190, bottom: 20),
                  alignment: Alignment.center,
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 5.0,
                    color: Colors.white,
                    child: Container(
                        width: 250,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Image(
                                height: 150,
                                width: 150,
                                image: AssetImage("assets/images/logo.png"),
                              ),
                            ),
                            Text(
                              "Inicia sesión con tu\ncuenta institucional",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "GoogleSans",
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.verdeDarkColor),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: new RaisedButton(
                                onPressed: () async {
                                  _signInWithGoogle();
                                },
                                child: Text(
                                  "Ingresar",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "GoogleSans",
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.colorAccent),
                                  textAlign: TextAlign.center,
                                ),
                                color: AppColors.verdeDarkLightColor,
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ]),
    );
  }

  _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (user != null) {
      _success = true;
      _userID = user.uid;
      if (currentUser.email.contains("itcelaya.edu")) {
        _onSuccess(context);
      } else {
        cerrarSesion();
        showDialog(
            context: context,
            builder: (context) => _onError(context, Strings.errorCI));
      }
    } else {
      cerrarSesion();
      showDialog(
          context: context,
          builder: (context) => _onError(context, Strings.errorCI));
    }
  }

  void cerrarSesion() async {
    _googleSignIn.signOut();
    _auth.signOut();
  }

  _onSuccess(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Principal()),
        ModalRoute.withName('/principal'));
  }

  _onError(BuildContext context, String texto) {
    return AssetGiffyDialog(
      image: Image.asset(
        'assets/images/errorf.gif',
        fit: BoxFit.cover,
      ),
      title: Text(
        'Error 😱',
        style: TextStyle(
            fontSize: 22,
            fontFamily: "GoogleSans",
            fontWeight: FontWeight.bold,
            color: AppColors.verdeDarkLightColor),
      ),
      description: Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 15,
            fontFamily: "GoogleSans",
            color: AppColors.azulMarino),
      ),
      onlyOkButton: true,
      buttonOkText: Text(
        "Aceptar",
        style: TextStyle(fontFamily: "GoogleSans", color: Colors.white),
      ),
      onOkButtonPressed: () {
        Navigator.pop(context);
      },
    );
  }
  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }
}
