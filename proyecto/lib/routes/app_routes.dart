import 'package:flutter/material.dart';
import 'package:proyecto/features/auth/login/login_screen.dart';
import 'package:proyecto/features/auth/register/register_screen.dart';
import 'package:proyecto/features/home/doctor_profile.dart';
import 'package:proyecto/features/home/home_screen.dart';
import 'package:proyecto/features/home/next_appointment_screen.dart';
import 'package:proyecto/features/users/users_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String doctor_profile = '/doctor_profile';
  static const String next_appointment_screen = '/next_appointment_screen';
  static const String user_profile = '/users_screen';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    doctor_profile: (context) => const DoctorProfile(),
    next_appointment_screen: (context) => const NextAppointmentScreen(),
    user_profile: (context) => const UserScreen()
  };
}
