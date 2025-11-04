import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto/theme/app_colors.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; 

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final clientId = '418019899255-005b27g92epb40rd13vlofamajhlvi36.apps.googleusercontent.com';

  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      if (mounted) {
        Navigator.pushNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String message = "Error desconocido";
      if (e.code == 'user-not-found') {
        message = "Usuario no encontrado";
      } else if (e.code == 'wrong-password') {
        message = "Contraseña incorrecta";
      } else if (e.code == 'invalid-email') {
        message = "Correo no válido";
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
              'Inicio de Sesión',
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            AppTextField(
              controller: _emailCtrl,
              label: "Correo",
              hint: "ingresa@tu.correo",
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
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  if (_emailCtrl.text.trim().isNotEmpty) {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _emailCtrl.text.trim())
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Se ha enviado un correo para restablecer tu contraseña."),
                        ),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Ingresa tu correo para enviar el enlace de recuperación."),
                      ),
                    );
                  }
                },
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

            PrimaryButton(
              text: _isLoading ? "Cargando..." : "Iniciar Sesión",
              onPressed: _isLoading ? null : _onSubmit,
            ),
           
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GoogleSignInButton(
                clientId: clientId,
                loadingIndicator: const CircularProgressIndicator(),
                onSignedIn: (user) {
                  Navigator.pushNamed(context, '/home');
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al iniciar sesión con Google')),
                  );
                },
              ),
            ),


          ],
        
        ),
      ),
    );
  }
}
