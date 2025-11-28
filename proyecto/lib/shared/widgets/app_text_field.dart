import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final bool obscure;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const AppTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.onChanged,
    this.obscure = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}
