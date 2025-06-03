import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:flutter/material.dart';

class PriorityLogic {
  static String getTranslatedPriorityDisplay(
    String priorityString,
    BuildContext context,
  ) {
    switch (priorityString.toLowerCase()) {
      case AppInternalConstants.priorityValueCritical:
        return AppStrings.priorityDisplayCritical(context).toUpperCase();
      case AppInternalConstants.priorityValueHigh:
        return AppStrings.priorityDisplayHigh(context).toUpperCase();
      case AppInternalConstants.priorityValueMedium:
        return AppStrings.priorityDisplayMedium(context).toUpperCase();
      case AppInternalConstants.priorityValueLow:
        return AppStrings.priorityDisplayLow(context).toUpperCase();
      default:
        return priorityString.toUpperCase();
    }
  }
}
