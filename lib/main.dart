import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const GamerApp());
}

class GamerApp extends StatelessWidget {
  const GamerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}