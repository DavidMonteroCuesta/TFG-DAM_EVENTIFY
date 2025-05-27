import 'package:flutter/material.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

class PriorityOptionChip extends StatelessWidget {
  final String label;
  final Priority priority;
  final Priority selectedPriority;
  final Color backgroundColor;
  final Color textColor;
  final ValueChanged<Priority> onSelected;

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
      // ignore: deprecated_member_use
      backgroundColor: backgroundColor.withOpacity(0.3),
      selectedColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      side: BorderSide(
        color: isSelected ? backgroundColor : AppColors.choiceChipBorderColor,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
