import 'package:flutter/material.dart';
import 'home_screen.dart';

class BublikMeterApp extends StatelessWidget {
  const BublikMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Бубликометр',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
          primary: Colors.lightGreen,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
      ),
      home: const HomeScreen(),
    );
  }
}