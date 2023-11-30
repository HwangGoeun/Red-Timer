import 'package:flutter/material.dart';
import 'package:redtimer/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.red[300],
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
          ),
        ),
        cardColor: Colors.black,
      ),
      home: const HomeScreen(),
    );
  }
}
