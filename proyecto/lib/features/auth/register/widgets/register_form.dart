import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(_nameCtrl.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro exitoso")),
        );
        Navigator.pushNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String message = "Error al registrar";
      if (e.code == 'email-already-in-use') {
        message = "Este correo ya está registrado";
      } else if (e.code == 'invalid-email') {
        message = "Correo inválido";
      } else if (e.code == 'weak-password') {
        message = "Contraseña demasiado débil";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

            PrimaryButton(
              text: _isLoading ? "Cargando..." : "Registrarse",
              onPressed: _isLoading ? null : _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
