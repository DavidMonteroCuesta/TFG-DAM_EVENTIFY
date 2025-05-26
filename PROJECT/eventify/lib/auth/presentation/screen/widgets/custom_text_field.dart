import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final TextEditingController? controller;
  final TextStyle textStyle; // Added textStyle parameter

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscure = false,
    this.controller,
    required this.textStyle, // Made textStyle required
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: textStyle.copyWith(color: AppColors.textPrimary), // Using AppColors and textStyle
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyle.copyWith(color: AppColors.textBody2Grey), // Using AppColors and textStyle
        filled: true,
        fillColor: AppColors.inputFillColor, // Using AppColors
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
