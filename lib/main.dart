// main.dart
import 'package:flutter/material.dart';
import 'pages/splash.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Georges Final Project at DCLIC Training',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}
