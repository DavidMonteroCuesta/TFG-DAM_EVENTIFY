import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

/// Campo de búsqueda reutilizable para los formularios de búsqueda de eventos
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String)? onChanged;

  static const double _borderRadius = 10.0;
  static const double _focusedBorderWidth = 1.5;
  static const double _contentPaddingH = 16.0;
  static const double _contentPaddingV = 12.0;
  static const double _verticalPadding = 8.0;

  const SearchField({
    super.key,
    required this.controller,
    required this.labelText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: TextFormField(
        controller: controller,
        style: TextStyles.plusJakartaSansBody1,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyles.plusJakartaSansSubtitle2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(
              color: AppColors.focusedBorderDynamic,
              width: _focusedBorderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: _contentPaddingH,
            vertical: _contentPaddingV,
          ),
          filled: true,
          fillColor: AppColors.inputFillColor,
        ),
      ),
    );
  }
}
