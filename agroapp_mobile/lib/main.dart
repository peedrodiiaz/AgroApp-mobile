import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const TestScreen(),
    );
  }
}


class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgroApp Test'),
      ),
      body: const Center(
        child: Text(
          'AgroApp - Configuración OK ✅',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
