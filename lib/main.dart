import 'package:flutter/material.dart';
import 'package:prueba/Actividades/LogIn.dart';
import 'package:prueba/Actividades/Principal.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semana Lince',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/principal': (BuildContext context) => new Principal(),
        '/logIn': (BuildContext context) => new LogIn(),
      },
      home: new LogIn(),
    );
  }
}
