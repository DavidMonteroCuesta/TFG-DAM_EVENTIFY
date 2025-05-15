import 'package:eventify/calendar/presentation/screen/widgets/month_row.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  final List<String> months = const [
    'JANUARY', 'FEBRUARY', 'MARCH',
    'APRIL', 'MAY', 'JUNE',
    'JULY', 'AUGUST', 'SEPTEMBER',
    'OCTOBER', 'NOVEMBER', 'DECEMBER',
  ];

  final List<int> notifications = const [
    0, 7, 0,
    5, 0, 4,
    0, 3, 9,
    0, 1, 0,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildMonthRows(MediaQuery.of(context).size.width),
    );
  }

  List<Widget> _buildMonthRows(double screenWidth) {
    final List<Widget> rows = [];
    int itemsPerRow = 3;
    if (screenWidth >= 900) {
      itemsPerRow = 3;
    } else if (screenWidth > 600) {
      itemsPerRow = 3;
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