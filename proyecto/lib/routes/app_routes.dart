import 'package:flutter/material.dart';
import 'package:proyecto/features/auth/login/login_screen.dart';
import 'package:proyecto/features/auth/register/register_screen.dart';
import 'package:proyecto/features/home/doctor_profile.dart';
import 'package:proyecto/features/home/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String doctor_profile = '/doctor_profile';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    doctor_profile: (context) => const DoctorProfile()
  };
}
