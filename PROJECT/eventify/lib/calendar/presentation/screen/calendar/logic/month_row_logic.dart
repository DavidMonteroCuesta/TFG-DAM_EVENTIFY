import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';

class MonthRowLogic {
  static int getGlobalMonthIndex(BuildContext context, String monthName) {
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
