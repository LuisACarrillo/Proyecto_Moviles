import 'package:flutter/material.dart';
import 'package:proyecto/routes/app_routes.dart';
import 'package:proyecto/theme/app_theme.dart';
import 'package:proyecto/shared/state/theme_controller.dart';
import 'package:proyecto/features/auth/login/login_screen.dart';

final ThemeController themeController = ThemeController();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'MALUIAN Pets App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          home: const LoginScreen(),
          routes: AppRoutes.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
