import 'package:flutter/material.dart';

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
        color: Colors.white,
        size: 24.0,
      ),
      tooltip: isMonthlyView ? 'Show yearly view' : 'Show monthly view',
    );
  }
}
