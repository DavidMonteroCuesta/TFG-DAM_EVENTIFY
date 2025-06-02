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
    final Map<String, String> abbreviatedToFullMonth = {
      'Jan': AppStrings.monthJanuary(context),
      'Feb': AppStrings.monthFebruary(context),
      'Mar': AppStrings.monthMarch(context),
      'Apr': AppStrings.monthApril(context),
      'May': AppStrings.monthMay(context),
      'Jun': AppStrings.monthJune(context),
      'Jul': AppStrings.monthJuly(context),
      'Aug': AppStrings.monthAugust(context),
      'Sep': AppStrings.monthSeptember(context),
      'Oct': AppStrings.monthOctober(context),
      'Nov': AppStrings.monthNovember(context),
      'Dec': AppStrings.monthDecember(context),
    };
    final String resolvedMonthName =
        abbreviatedToFullMonth[monthName] ?? monthName;
    return allMonths.indexOf(resolvedMonthName) + 1;
  }
}
