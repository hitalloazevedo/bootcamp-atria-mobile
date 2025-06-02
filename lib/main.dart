import 'package:flutter/material.dart';
import 'package:teste_flutter/cards/edit_task.dart';
import 'package:teste_flutter/login.dart';
import 'package:teste_flutter/inicio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AtriaJr App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: InicioPage(),
    );
  }
}
