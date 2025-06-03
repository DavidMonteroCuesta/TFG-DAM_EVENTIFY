// ignore_for_file: deprecated_member_use

import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

/// Selector de prioridad reutilizable para filtrar eventos por prioridad
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

  static const double _chipSelectedOpacity = 0.8;
  static const double _chipUnselectedOpacity = 0.5;
  static const double _chipBorderRadius = 8.0;
  static const double _chipLabelPaddingH = 12.0;
  static const double _chipLabelPaddingV = 8.0;
  static const double _switchActiveOpacity = 0.8;
  static const double _rowSpacing = 10.0;
  static const double _wrapSpacing = 8.0;
  static const double _verticalPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.priority(context),
                style: TextStyles.plusJakartaSansSubtitle2,
              ),
              const SizedBox(width: _rowSpacing),
              // Switch para activar y desactivar el filtro de prioridad
              Switch(
                value: enablePriorityFilter,
                onChanged: onEnableChanged,
                activeColor: AppColors.focusedBorderDynamic.withOpacity(
                  _switchActiveOpacity,
                ),
                inactiveTrackColor: AppColors.switchInactiveTrackColor,
                inactiveThumbColor: AppColors.switchInactiveThumbColor,
              ),
            ],
          ),
          const SizedBox(height: _verticalPadding),
          // Opciones de prioridad solo si el filtro está activado
          Visibility(
            visible: enablePriorityFilter,
            child: Wrap(
              spacing: _wrapSpacing,
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

  // Construye cada opción de prioridad como un ChoiceChip
  Widget _buildPriorityOption(String label, Priority priority) {
    final isSelected = selectedPriority == priority;
    return Builder(
      builder: (context) {
        final Color chipColor = AppColors.secondaryDynamic.withOpacity(
          isSelected ? _chipSelectedOpacity : _chipUnselectedOpacity,
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
            borderRadius: BorderRadius.circular(_chipBorderRadius),
          ),
          side: BorderSide(
            color: isSelected ? chipColor : AppColors.choiceChipBorderColor,
          ),
          labelPadding: const EdgeInsets.symmetric(
            horizontal: _chipLabelPaddingH,
            vertical: _chipLabelPaddingV,
          ),
        );
      },
    );
  }
}
