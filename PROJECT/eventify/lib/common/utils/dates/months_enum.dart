import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';

enum Month {
  january('January'),
  february('February'),
  march('March'),
  april('April'),
  may('May'),
  june('June'),
  july('July'),
  august('August'),
  september('September'),
  october('October'),
  november('November'),
  december('December');

  final String abbreviation;

  const Month(this.abbreviation);

  String localizedName(BuildContext context) {
    switch (this) {
      case Month.january:
        return AppStrings.monthJanuary(context);
      case Month.february:
        return AppStrings.monthFebruary(context);
      case Month.march:
        return AppStrings.monthMarch(context);
      case Month.april:
        return AppStrings.monthApril(context);
      case Month.may:
        return AppStrings.monthMay(context);
      case Month.june:
        return AppStrings.monthJune(context);
      case Month.july:
        return AppStrings.monthJuly(context);
      case Month.august:
        return AppStrings.monthAugust(context);
      case Month.september:
        return AppStrings.monthSeptember(context);
      case Month.october:
        return AppStrings.monthOctober(context);
      case Month.november:
        return AppStrings.monthNovember(context);
      case Month.december:
        return AppStrings.monthDecember(context);
    }
  }

  static Month fromInt(int month) {
    return Month.values[month - 1];
  }
}
