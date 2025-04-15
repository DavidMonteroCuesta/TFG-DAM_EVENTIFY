import 'package:eventify/generated/l10n.dart';
import 'package:flutter/material.dart';

class ForgotPasswordOption extends StatelessWidget {
  const ForgotPasswordOption({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Center(
      child: GestureDetector(
        onTap: () {
          // Lógica para recuperar contraseña
        },
        child: Text(
          localizations.forgotPassword,
          style: const TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}