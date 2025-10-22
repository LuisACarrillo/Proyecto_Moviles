import 'package:flutter/material.dart';
import 'package:proyecto/features/appointments/appointment_form_screen.dart';
import 'package:proyecto/features/auth/login/login_screen.dart';
import 'package:proyecto/features/auth/register/register_screen.dart';
import 'package:proyecto/features/home/doctor_profile.dart';
import 'package:proyecto/features/home/home_screen.dart';
import 'package:proyecto/features/home/next_appointment_screen.dart';
import 'package:proyecto/features/pets/pet_edit_screen.dart';
import 'package:proyecto/features/pets/pet_profile_screen.dart';
import 'package:proyecto/features/users/users_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String doctorProfile = '/doctor_profile';
  static const String nextAppointmentScreen = '/next_appointment_screen';
  static const String userProfile = '/users_screen';
  static const String petProfile = '/pet-profile';
  static const String petEdit = '/pet-edit';
  static const String appointmentForm = '/appointment-form';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    doctorProfile: (context) => const DoctorProfile(),
    nextAppointmentScreen: (context) => const NextAppointmentScreen(),
    userProfile: (context) => const UserScreen(),
    petProfile: (context) => const PetProfileScreen(),
    petEdit: (context) => const PetEditScreen(),
    appointmentForm: (context) => const AppointmentFormScreen(),
  };
}
