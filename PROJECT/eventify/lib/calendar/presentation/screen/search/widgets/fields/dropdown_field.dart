import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

class DropdownField<T> extends StatelessWidget {
  static const double _verticalPadding = 8.0;
  static const double _borderRadius = 10.0;
  static const double _contentPaddingHorizontal = 16.0;
  static const double _contentPaddingVertical = 12.0;
  static const double _focusedBorderWidth = 1.5;

  final T? value;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final String labelText;

  const DropdownField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: DropdownButtonFormField<T>(
        value: value,
        onChanged: onChanged,
        items: items,
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
            horizontal: _contentPaddingHorizontal,
            vertical: _contentPaddingVertical,
          ),
          filled: true,
          fillColor: AppColors.inputFillColor,
        ),
        style: TextStyles.plusJakartaSansBody2,
      ),
    );
  }
}
