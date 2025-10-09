import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    // 🎯 Texto más oscuro y con mejor contraste sobre beige
    const onSurfaceStrong = Color(0xFF1A1F1A); // casi negro, cálido

    final cs = ColorScheme.light(
      primary: AppColors.primaryGreen,
      secondary: AppColors.accentGold,
      surface: AppColors.secondaryBeige,
    ).copyWith(
      onPrimary: AppColors.backgroundIvory,
      onSurface: onSurfaceStrong,            // <- antes: Colors.black87
      onSurfaceVariant: Color(0xFF4A4F4A),   // subtítulos / labels
      outline: Color(0xFF7A7F7A),           // divisores/bordes sutiles
    );

    final txt = const TextTheme().apply(
      bodyColor: onSurfaceStrong,
      displayColor: onSurfaceStrong,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cs,
      textTheme: txt,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.backgroundIvory,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundIvory,
        foregroundColor: AppColors.primaryGreen,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: AppColors.primaryGreen,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surface,
        prefixIconColor: cs.primary,
        // Hints un poco más oscuros para legibilidad
        hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.55)),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: cs.primary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundIvory,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurface.withValues(alpha: 0.6),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      dividerColor: cs.outline.withValues(alpha: 0.35),
      cardColor: cs.surface,
    );
  }

  static ThemeData get darkTheme {
    const bg = Color(0xFF121512);
    const surface = Color(0xFF1C211C);
    const hint = Color(0xFF8C8F8C);

    final cs = ColorScheme.dark(
      primary: AppColors.primaryGreen,
      secondary: AppColors.accentGold,
      surface: surface,
    ).copyWith(
      onPrimary: Colors.white,
      onSurface: Colors.white.withValues(alpha: 0.92),     // más legible
      onSurfaceVariant: Colors.white.withValues(alpha: 0.7),
      outline: Colors.white.withValues(alpha: 0.28),
    );

    final txt = const TextTheme().apply(
      bodyColor: cs.onSurface,
      displayColor: cs.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      textTheme: txt,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: bg,

      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.white,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        prefixIconColor: cs.primary,
        hintStyle: const TextStyle(color: hint),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: cs.primary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurface.withValues(alpha: 0.7),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      dividerColor: cs.outline,
      cardColor: cs.surface,
    );
  }
}
