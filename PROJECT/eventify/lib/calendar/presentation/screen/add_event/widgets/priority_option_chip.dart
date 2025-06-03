// ignore_for_file: deprecated_member_use

import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class PriorityOptionChip extends StatelessWidget {
  final String label;
  final Priority priority;
  final Priority selectedPriority;
  final Color backgroundColor;
  final Color textColor;
  final ValueChanged<Priority> onSelected;

  static const double _chipBackgroundOpacity = 0.3;
  static const double _chipBorderRadius = 8.0;
  static const double _chipLabelPaddingH = 6.0;
  static const double _chipLabelPaddingV = 8.0;

  const PriorityOptionChip({
    super.key,
    required this.label,
    required this.priority,
    required this.selectedPriority,
    required this.backgroundColor,
    required this.textColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedPriority == priority;
    // Devuelve un ChoiceChip personalizado para la prioridad
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color:
              isSelected
                  ? textColor
                  : AppColors.priorityOptionSelectedTextColor,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          onSelected(priority);
        }
      },
      backgroundColor: backgroundColor.withOpacity(_chipBackgroundOpacity),
      selectedColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_chipBorderRadius),
      ),
      side: BorderSide(
        color: isSelected ? backgroundColor : AppColors.choiceChipBorderColor,
      ),
      labelPadding: const EdgeInsets.symmetric(
        horizontal: _chipLabelPaddingH,
        vertical: _chipLabelPaddingV,
      ),
    );
  }
}
