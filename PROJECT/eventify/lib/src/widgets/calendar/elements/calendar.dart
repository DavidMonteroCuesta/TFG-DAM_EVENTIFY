import 'package:eventify/src/widgets/calendar/elements/month_row.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  Calendar({super.key});

  final List<String> months = const [
    'January', 'February', 'March',
    'April', 'May', 'June',
    'July', 'August', 'September',
    'October', 'November', 'December',
  ];

  final List<int> notifications = List.generate(12, (index) => 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: _buildMonthRows(MediaQuery.of(context).size.width),
      ),
    );
  }

  List<Widget> _buildMonthRows(double screenWidth) {
    final List<Widget> rows = [];
    int itemsPerRow = 3;
    if (screenWidth >= 900) {
      itemsPerRow = 3;
    } else if (screenWidth > 600) {
      itemsPerRow = 2;
    }

    for (int i = 0; i < months.length; i += itemsPerRow) {
      final end = i + itemsPerRow > months.length ? months.length : i + itemsPerRow;
      final rowMonths = months.sublist(i, end);
      rows.add(
        MonthRow(rowMonths: rowMonths, rowNotifications: notifications.sublist(i, end)),
      );
    }
    return rows;
  }
}