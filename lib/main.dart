import 'package:flutter/material.dart';

import 'pages/home_page.dart';

// Ponto de partida do app.
void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF5B4BB7),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
