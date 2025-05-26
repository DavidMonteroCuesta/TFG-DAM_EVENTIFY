import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart'; // Import AppStrings

class ForgotPasswordOption extends StatelessWidget {
  const ForgotPasswordOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Lógica para recuperar contraseña
        },
        child: Text(
          AppStrings.forgotPasswordOptionText(context),
          style: TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
