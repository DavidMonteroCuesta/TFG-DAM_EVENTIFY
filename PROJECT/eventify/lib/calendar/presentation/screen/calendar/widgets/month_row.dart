import 'package:eventify/calendar/presentation/screen/calendar/widgets/month_item.dart';
import 'package:flutter/material.dart';
import 'package:eventify/calendar/presentation/screen/calendar/logic/month_row_logic.dart';

class MonthRow extends StatelessWidget {
  final List<String> rowMonths;
  final List<int> rowNotifications;
  final Function(int monthIndex)? onMonthTap;
  final TextStyle? textStyle;

  const MonthRow({
    super.key,
    required this.rowMonths,
    required this.rowNotifications,
    this.onMonthTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            rowMonths.asMap().entries.map((entry) {
              final index = entry.key;
              final month = entry.value;
              final int globalMonthIndex = MonthRowLogic.getGlobalMonthIndex(
                context,
                month,
              );

              return Expanded(
                child: MonthItem(
                  monthName: month,
                  notificationCount: rowNotifications[index],
                  onTap:
                      onMonthTap != null && globalMonthIndex != -1
                          ? () => onMonthTap!(globalMonthIndex)
                          : null,
                  textStyle: textStyle,
                ),
              );
            }).toList(),
      ),
    );
  }
}
