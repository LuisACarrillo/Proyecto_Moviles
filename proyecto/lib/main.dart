import 'package:flutter/material.dart';
import 'package:proyecto/features/auth/login/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MALUIAN Pets App',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
