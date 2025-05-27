import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors

class CalendarToggleButton extends StatelessWidget {
  final VoidCallback onToggleCalendar;
  final bool isMonthlyView;

  const CalendarToggleButton({
    super.key,
    required this.onToggleCalendar,
    required this.isMonthlyView,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggleCalendar,
      icon: Icon(
        isMonthlyView ? Icons.calendar_view_month : Icons.calendar_today,
        color: AppColors.footerIconColor, // Using AppColors for consistency
        size: 24.0,
      ),
      tooltip: isMonthlyView
          ? AppStrings.calendarToggleShowYearlyViewTooltip(context)
          : AppStrings.calendarToggleShowMonthlyViewTooltip(context),
    );
  }
}
