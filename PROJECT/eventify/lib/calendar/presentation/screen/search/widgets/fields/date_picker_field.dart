import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget de campo selector de fecha reutilizable para formularios de búsqueda.
class DatePickerField extends StatelessWidget {
  static const double _verticalPadding = 8.0;
  static const double _borderRadius = 10.0;
  static const double _contentPaddingHorizontal = 16.0;
  static const double _contentPaddingVertical = 12.0;
  static const double _focusedBorderWidth = 1.5;

  final DateTime? selectedDate;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final BuildContext contextForStrings;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onTap,
    this.onClear,
    required this.contextForStrings,
  });

  @override
  Widget build(BuildContext context) {
    // Campo de selección de fecha para búsqueda de eventos.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: AppStrings.searchFieldDate(
              contextForStrings,
            ),
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
            suffixIcon:
                selectedDate != null && onClear != null
                    ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: onClear,
                    )
                    : const Icon(
                      Icons.calendar_today,
                      color: AppColors.textSecondary,
                    ),
          ),
          child: Text(
            selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                : AppStrings.searchFieldSelectDate(contextForStrings),
            style:
                selectedDate != null
                    ? TextStyles.plusJakartaSansBody1
                    : TextStyles.plusJakartaSansSubtitle2,
          ),
        ),
      ),
    );
  }
}
