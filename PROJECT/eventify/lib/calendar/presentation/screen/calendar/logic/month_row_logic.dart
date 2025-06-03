import 'package:eventify/common/constants/app_strings.dart';
import 'package:flutter/material.dart';

// Lógica para obtener el índice global de un mes a partir de su nombre.
class MonthRowLogic {
  static const int _firstMonthIndex = 1;

  // Devuelve el índice global del mes según su nombre localizado.
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
    final String resolvedMonthName = monthName;
    return allMonths.indexOf(resolvedMonthName) + _firstMonthIndex;
  }
}
