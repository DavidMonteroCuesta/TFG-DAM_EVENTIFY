import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/colors.dart'; // Import AppColors

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor400, // Using AppColors
          foregroundColor: AppColors.elevatedButtonForeground, // Using AppColors
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: AppColors.textPrimary), // Using AppColors
        ),
      ),
    );
  }
}
