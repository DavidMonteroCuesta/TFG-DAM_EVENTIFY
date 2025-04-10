import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final TextEditingController? controller; // Añade esta línea

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscure = false,
    this.controller, // Añade esta línea
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Usa el controller proporcionado
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}