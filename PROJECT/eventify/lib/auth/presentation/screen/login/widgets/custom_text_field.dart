import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

const double kCustomTextFieldBorderRadius = 8.0;

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final TextEditingController? controller;
  final TextStyle textStyle;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscure = false,
    this.controller,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: textStyle.copyWith(
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyle.copyWith(
          color: AppColors.textBody2Grey,
        ),
        filled: true,
        fillColor: AppColors.inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCustomTextFieldBorderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
