import 'package:eventify/calendar/presentation/screen/widgets/month_item.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart'; // Import the AppStrings constants

class MonthRow extends StatelessWidget {
  final List<String> rowMonths;
  final List<int> rowNotifications;
  final Function(int monthIndex)? onMonthTap;

  const MonthRow({
    super.key,
    required this.rowMonths,
    required this.rowNotifications,
    this.onMonthTap,
  });

  @override
  Widget build(BuildContext context) { // context is available here
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowMonths.asMap().entries.map((entry) {
          final index = entry.key;
          final month = entry.value;
          // Pass context to _getGlobalMonthIndex
          final int globalMonthIndex = _getGlobalMonthIndex(context, month);

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

  // Add BuildContext context as a parameter
  int _getGlobalMonthIndex(BuildContext context, String monthName) {
    // Pass context to all AppStrings calls
    final List<String> allMonths = [
      AppStrings.monthJanuary(context),
      AppStrings.monthFebruary(context),
      AppStrings.monthMarch(context),
      AppStrings.monthApril(context),
      AppStrings.monthMay(context),
      AppStrings.monthJune(context),
      AppStrings.monthJuly(context),
      AppStrings.monthAugust(context),
      AppStrings.monthSeptember(context),
      AppStrings.monthOctober(context),
      AppStrings.monthNovember(context),
      AppStrings.monthDecember(context),
    ];
    return allMonths.indexOf(monthName) + 1;
  }
}