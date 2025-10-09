import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/theme/app_colors.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registro validado")));
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
              'Crear Cuenta',
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            // Name
            AppTextField(
              controller: _nameCtrl,
              label: "Nombre completo",
              hint: "Juan Pérez",
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Por favor ingresa tu nombre";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Email
            AppTextField(
              controller: _emailCtrl,
              label: "Correo",
              hint: "correo@ejemplo.com",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Por favor ingresa tu correo";
                }
                if (!value.contains('@')) {
                  return "Correo no válido";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Password
            AppTextField(
              controller: _passCtrl,
              label: "Contraseña",
              hint: "••••••••",
              icon: Icons.lock_outline_rounded,
              obscure: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor ingresa tu contraseña";
                }
                if (value.length < 6) {
                  return "Mínimo 6 caracteres";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Confirm Password
            AppTextField(
              controller: _confirmPassCtrl,
              label: "Confirmar Contraseña",
              hint: "••••••••",
              icon: Icons.lock_outline,
              obscure: true,
              validator: (value) {
                if (value != _passCtrl.text) {
                  return "Las contraseñas no coinciden";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            PrimaryButton(text: "Registrarse", onPressed: _onSubmit),
          ],
        ),
      ),
    );
  }
}
