import 'package:flutter/material.dart';
import 'package:proyecto/features/auth/login/login_screen.dart';
import 'package:proyecto/features/auth/register/register_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
  };
}
