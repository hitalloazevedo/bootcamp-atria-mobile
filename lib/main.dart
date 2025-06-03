import 'package:flutter/material.dart';
import 'package:teste_flutter/login.dart';
import 'package:teste_flutter/inicio.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AtriaJr App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),

      // Define a rota inicial a ser carregada
      initialRoute: '/login', // Ou qualquer outra rota que deva ser a primeira

      // Define todas as suas rotas nomeadas
      routes: {
        '/login': (context) => LoginPage(),
        '/inicio': (context) => const InicioPage(),
        // ... outras rotas
      },
    );
  }
}