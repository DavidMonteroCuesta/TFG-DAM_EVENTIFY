import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors

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
            color: AppColors.textSecondary, // Using AppColors
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
