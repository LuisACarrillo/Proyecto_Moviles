import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.backgroundIvory,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentGold,
        surface: AppColors.secondaryBeige,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.primaryGreen,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: AppColors.neutralGray),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondaryBeige,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryGreen),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        hintStyle: const TextStyle(color: AppColors.neutralGray),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.backgroundIvory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
