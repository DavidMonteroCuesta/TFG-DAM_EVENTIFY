import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

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

  static const double _inputFontSize = 16.0;
  static const double _inputBorderRadius = 10.0;
  static const double _inputFocusedBorderWidth = 1.5;
  static const double _inputContentPaddingH = 16.0;
  static const double _inputContentPaddingV = 12.0;

  @override
  Widget build(BuildContext context) {
    // Campo de texto para el título del evento con estilos personalizados
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: _inputFontSize,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.plusJakartaSansSubtitle2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputBorderRadius),
          borderSide: BorderSide(
            color: secondaryColor,
            width: _inputFocusedBorderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: _inputContentPaddingH,
          vertical: _inputContentPaddingV,
        ),
        filled: true,
        fillColor: AppColors.inputFillColor,
      ),
      validator: validator,
    );
  }
}
