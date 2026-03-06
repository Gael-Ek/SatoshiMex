import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Colores base del diseño
    final Color colorFondoCampo = const Color(0xFF1A1D2A);
    final Color colorBorde = const Color(0xFF2E3348);
    final Color colorIconosTexto = const Color(0xFF7A839E);
    final Color colorTextoPrincipal = Colors.white;

    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: colorTextoPrincipal),
      decoration: InputDecoration(
        filled: true,
        fillColor: colorFondoCampo,
        hintText: hintText,
        hintStyle: TextStyle(color: colorIconosTexto),
        prefixIcon: Icon(prefixIcon, color: colorIconosTexto),
        suffixIcon: suffixIcon, // Para poner el ojito si lo necesitas
        // Bordes
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorBorde, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
    );
  }
}
