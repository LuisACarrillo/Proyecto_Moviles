import 'package:flutter/material.dart';
import 'package:proyecto/theme/app_colors.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Campos validados")));
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Inicio de Sesión',
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            // Email
            AppTextField(
              controller: _emailCtrl,
              label: "Correo",
              hint: "ingresa@tu.correo",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              // validator: (value) {
              //   if (value == null || value.trim().isEmpty) {
              //     return "Por favor ingresa tu correo";
              //   }
              //   if (!value.contains('@')) {
              //     return "Correo no válido";
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 12),

            // Password
            AppTextField(
              controller: _passCtrl,
              label: "Contraseña",
              hint: "••••••••",
              icon: Icons.lock_outline_rounded,
              obscure: true,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "Por favor ingresa tu contraseña";
              //   }
              //   if (value.length < 6) {
              //     return "Mínimo 6 caracteres";
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            PrimaryButton(text: "Iniciar Sesión", onPressed: _onSubmit),
          ],
        ),
      ),
    );
  }
}
