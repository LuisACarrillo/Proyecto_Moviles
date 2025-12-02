import "package:flutter/material.dart";
import "package:proyecto/features/appointments/appointment_form_screen.dart";
import "package:proyecto/features/auth/login/login_screen.dart";
import "package:proyecto/features/auth/register/register_screen.dart";
import "package:proyecto/features/grooming/grooming_screen.dart";
import "package:proyecto/features/home/doctor_profile.dart";
import "package:proyecto/features/home/food_profile.dart";
import "package:proyecto/features/home/home_screen.dart";
import "package:proyecto/features/home/next_appointment_screen.dart";
import "package:proyecto/features/home/vet_profile.dart";
import "package:proyecto/features/pets/pet_edit_screen.dart";
import "package:proyecto/features/pets/pet_create_screen.dart";
import "package:proyecto/features/pets/pet_profile_screen.dart";
import "package:proyecto/features/store/cart_screen.dart";
import "package:proyecto/features/store/store_demo_screen.dart";
import "package:proyecto/features/store/store_screen.dart";
import "package:proyecto/features/store/stripe_checkout_screen.dart";
import "package:proyecto/features/users/users_screen.dart";
import "package:proyecto/features/vets/vets_screen.dart";
import "package:proyecto/features/walks/walk_screen.dart";
import "package:proyecto/features/reviews/doctor_review.dart";


class AppRoutes {
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";
  static const String doctorProfile = "/doctor_profile";
  static const String nextAppointmentScreen = "/next_appointment_screen";
  static const String userProfile = "/users_screen";
  static const String petProfile = "/pet-profile";
  static const String petEdit = "/pet-edit";
  static const String petCreate = "/pet-create";
  static const String appointmentForm = "/appointment-form";
  static const String grooming = "/grooming";
  static const String vets = "/vets";
  static const String walks = "/walks";
  static const String store = "/store";
  static const String storeDemo = "/store-demo";
  static const String cart = "/cart";
  static const String stripeCheckout = "/stripe-checkout";
  static const String doctorReview = "/doctor_review";
  static const String vetProfile = "/vet-profile";

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    doctorProfile: (context) => const DoctorProfile(),
    nextAppointmentScreen: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final String id = (args is String) ? args : "";
      return NextAppointmentScreen(citaId: id);
    },
    userProfile: (context) => const UserScreen(),
    petProfile: (context) => const PetProfileScreen(),
    petEdit: (context) => const PetEditScreen(),
    petCreate: (context) => const PetCreateScreen(),
    appointmentForm: (context) => const AppointmentFormScreen(),
    grooming: (context) => const GroomingScreen(),
    vets: (context) => const VetsScreen(),
    walks: (context) => const WalksScreen(),
    store: (context) => const StoreScreen(),
    storeDemo: (context) => const StoreDemoScreen(),
    cart: (context) => const CartScreen(),
    stripeCheckout: (context) => const StripeCheckoutScreen(),
    doctorReview: (context) => const DoctorReviewScreen(),
    vetProfile: (context) => const VetProfile(),
  };
}