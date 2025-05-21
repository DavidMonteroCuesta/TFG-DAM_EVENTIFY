import 'package:eventify/calendar/presentation/screen/widgets/month_item.dart';
import 'package:flutter/material.dart';

class MonthRow extends StatelessWidget {
  final List<String> rowMonths;
  final List<int> rowNotifications;
  final Function(int monthIndex)? onMonthTap; // Nuevo callback

  const MonthRow({
    super.key,
    required this.rowMonths,
    required this.rowNotifications,
    this.onMonthTap, // Nuevo parámetro
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowMonths.asMap().entries.map((entry) {
          final index = entry.key;
          final month = entry.value;
          // Calculamos el índice del mes (1-12) basado en su posición en la lista `months` global
          final int globalMonthIndex = _getGlobalMonthIndex(month);

          return Expanded(
            child: MonthItem(
              monthName: month,
              notificationCount: rowNotifications[index],
              onTap: onMonthTap != null && globalMonthIndex != -1
                  ? () => onMonthTap!(globalMonthIndex)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Helper para obtener el índice global del mes (1-12)
  int _getGlobalMonthIndex(String monthName) {
    final List<String> allMonths = const [
      'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
      'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER',
    ];
    return allMonths.indexOf(monthName) + 1;
  }
}
