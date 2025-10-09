import 'package:flutter/material.dart';
import 'package:proyecto/features/auth/login/widgets/login_form.dart';
import 'package:proyecto/features/auth/login/widgets/logo_header.dart';
import 'package:proyecto/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const LogoHeader(),
                  const SizedBox(height: 24),
                  const LoginForm(),
                  const SizedBox(height: 16),

                  // Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes una cuenta? ',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Regístrate',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  Text(
                    'Cuidado de Mascotas • Grooming • Veterinarios',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
