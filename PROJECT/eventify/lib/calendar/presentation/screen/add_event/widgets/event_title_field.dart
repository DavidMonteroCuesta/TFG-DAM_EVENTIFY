import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';

class EventTitleField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Color secondaryColor;

  const EventTitleField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validator,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 16.0, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.plusJakartaSansSubtitle2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: secondaryColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        filled: true,
        fillColor: AppColors.inputFillColor,
      ),
      validator: validator,
    );
  }
}
