import 'package:flutter/material.dart';

import './features/onboarding/presentation/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Congreso Educativo',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),

      home: const WelcomePage(),
    );
  }
}
