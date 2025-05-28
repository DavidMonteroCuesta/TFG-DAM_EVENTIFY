import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/constants/app_strings.dart';

class DatePickerField extends StatelessWidget {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: AppStrings.searchFieldDate(contextForStrings),
            labelStyle: TextStyles.plusJakartaSansSubtitle2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppColors.focusedBorderDynamic,
                width: 1.5,
              ),
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
