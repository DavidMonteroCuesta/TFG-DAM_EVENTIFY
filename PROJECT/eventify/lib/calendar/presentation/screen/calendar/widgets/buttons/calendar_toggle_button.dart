import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

// Widget que permite alternar entre la vista mensual y anual del calendario.
class CalendarToggleButton extends StatelessWidget {
  static const double _iconSize = 24.0;

  final VoidCallback onToggleCalendar;
  final bool isMonthlyView;

  const CalendarToggleButton({
    super.key,
    required this.onToggleCalendar,
    required this.isMonthlyView,
  });

  @override
  Widget build(BuildContext context) {
    // Botón para alternar la vista del calendario (mensual/anual).
    return IconButton(
      onPressed: onToggleCalendar,
      icon: Icon(
        isMonthlyView ? Icons.calendar_view_month : Icons.calendar_today,
        color: AppColors.footerIconColor,
        size: _iconSize,
      ),
      tooltip:
          isMonthlyView
              ? AppStrings.calendarToggleShowYearlyViewTooltip(context)
              : AppStrings.calendarToggleShowMonthlyViewTooltip(context),
    );
  }
}
