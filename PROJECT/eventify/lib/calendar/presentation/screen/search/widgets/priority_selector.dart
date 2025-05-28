import 'package:flutter/material.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';

class PrioritySelector extends StatelessWidget {
  final bool enablePriorityFilter;
  final ValueChanged<bool> onEnableChanged;
  final Priority? selectedPriority;
  final ValueChanged<Priority?> onPriorityChanged;
  final String labelCritical;
  final String labelHigh;
  final String labelMedium;
  final String labelLow;

  const PrioritySelector({
    super.key,
    required this.enablePriorityFilter,
    required this.onEnableChanged,
    required this.selectedPriority,
    required this.onPriorityChanged,
    required this.labelCritical,
    required this.labelHigh,
    required this.labelMedium,
    required this.labelLow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Prioridad', style: TextStyles.plusJakartaSansSubtitle2),
              const SizedBox(width: 10),
              Switch(
                value: enablePriorityFilter,
                onChanged: onEnableChanged,
                activeColor: AppColors.focusedBorderDynamic.withOpacity(0.8),
                inactiveTrackColor: AppColors.switchInactiveTrackColor,
                inactiveThumbColor: AppColors.switchInactiveThumbColor,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Visibility(
            visible: enablePriorityFilter,
            child: Wrap(
              spacing: 8.0,
              children: [
                _buildPriorityOption(labelCritical, Priority.critical),
                _buildPriorityOption(labelHigh, Priority.high),
                _buildPriorityOption(labelMedium, Priority.medium),
                _buildPriorityOption(labelLow, Priority.low),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityOption(String label, Priority priority) {
    final isSelected = selectedPriority == priority;
    return Builder(
      builder: (context) {
        final Color chipColor = AppColors.secondaryDynamic.withOpacity(
          isSelected ? 0.8 : 0.5,
        );
        return ChoiceChip(
          label: Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? AppColors.priorityOptionBackground
                      : AppColors.priorityOptionSelectedTextColor,
            ),
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            onPriorityChanged(selected ? priority : null);
          },
          backgroundColor: chipColor,
          selectedColor: chipColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          side: BorderSide(
            color: isSelected ? chipColor : AppColors.choiceChipBorderColor,
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      },
    );
  }
}
