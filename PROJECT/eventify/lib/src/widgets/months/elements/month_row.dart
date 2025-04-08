import 'package:eventify/src/widgets/months/elements/month_item.dart';
import 'package:flutter/material.dart';

class MonthRow extends StatelessWidget {
  final List<String> rowMonths;
  final List<int> rowNotifications;

  const MonthRow({super.key, required this.rowMonths, required this.rowNotifications});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowMonths.asMap().entries.map((entry) {
          final index = entry.key;
          final month = entry.value;
          return Expanded(
            child: MonthItem(monthName: month, notificationCount: rowNotifications[index]),
          );
        }).toList(),
      ),
    );
  }
}