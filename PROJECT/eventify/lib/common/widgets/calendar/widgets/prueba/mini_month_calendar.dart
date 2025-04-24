import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MiniMonthCalendar extends StatelessWidget {
  final DateTime month;

  const MiniMonthCalendar({
    super.key,
    required this.month,
  });

  List<Widget> _buildDayHeaders() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days
        .map((d) => Center(child: Text(d, style: const TextStyle(fontSize: 10, color: Colors.grey))))
        .toList();
  }

  List<Widget> _buildDays(DateTime month) {
    final List<Widget> days = [];
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final int startOffset = firstDay.weekday == 7 ? 0 : firstDay.weekday;

    for (int i = 0; i < startOffset; i++) {
      days.add(const SizedBox());
    }

    for (int i = 1; i <= daysInMonth; i++) {
      days.add(
        Center(
          child: Text(
            '$i',
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ),
      );
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat.MMM().format(month).toUpperCase();

    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      width: 140, // más ancho
      child: Column(
        children: [
          Text(
            monthLabel,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            shrinkWrap: true,
            children: [
              ..._buildDayHeaders(),
              ..._buildDays(month),
            ],
          ),
        ],
      ),
    );
  }
}
