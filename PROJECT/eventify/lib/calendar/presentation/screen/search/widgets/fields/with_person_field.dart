import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

/// Campo personalizado para filtrar eventos por persona asociada
class WithPersonField extends StatelessWidget {
  static const double _verticalPadding = 8.0;
  static const double _fontSize = 16.0;
  static const double _spaceWidth = 8.0;

  final bool withPersonYesNoSearch;
  final ValueChanged<bool?> onChanged;
  final TextEditingController controller;
  final String labelText;
  final String yesNoLabel;

  const WithPersonField({
    super.key,
    required this.withPersonYesNoSearch,
    required this.onChanged,
    required this.controller,
    required this.labelText,
    required this.yesNoLabel,
  });

  @override
  Widget build(BuildContext context) {
    // Campo para filtrar eventos por persona asociada, incluye checkbox para activar/desactivar filtro.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                yesNoLabel,
                style: TextStyles.plusJakartaSansBody1.copyWith(
                  fontSize: _fontSize,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: _spaceWidth),
              // Checkbox para activar y desactivar el filtro de persona
              Checkbox(
                value: withPersonYesNoSearch,
                onChanged: onChanged,
                activeColor: AppColors.focusedBorderDynamic,
                checkColor: AppColors.checkboxCheckColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
