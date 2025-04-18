import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final VoidCallback onToggleCalendar;
  final bool isMonthlyView;

  const Footer({
    super.key,
    required this.onToggleCalendar,
    required this.isMonthlyView,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final footerHeightPercentage = 0.08;
    final footerHeight = screenHeight * footerHeightPercentage;

    return Container(
      height: footerHeight,
      color: Colors.grey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.star_border, color: Colors.white, size: 24.0),
          const Icon(Icons.star_border, color: Colors.white, size: 24.0),
          IconButton(
            onPressed: onToggleCalendar,
            icon: Icon(
              isMonthlyView ? Icons.calendar_view_month : Icons.calendar_today,
              color: Colors.white,
              size: 24.0,
            ),
            tooltip: 'Altern calendar',
          ),
          const Icon(Icons.star_border, color: Colors.white, size: 24.0),
        ],
      ),
    );
  }
}