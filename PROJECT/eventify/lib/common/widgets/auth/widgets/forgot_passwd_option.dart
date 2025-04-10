// Widget separado para la opción de "Forgot Password?"
import 'package:flutter/material.dart';

class ForgotPasswordOption extends StatelessWidget {
  const ForgotPasswordOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Lógica para recuperar contraseña
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}