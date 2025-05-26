import 'package:flutter/material.dart'; // Import flutter material for Color
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors

enum Priority {
  critical,
  high,
  medium,
  low,
}

extension PriorityExtension on Priority {
  String get key {
    switch (this) {
      case Priority.critical:
        return 'priorityDisplayCritical';
      case Priority.high:
        return 'priorityDisplayHigh';
      case Priority.medium:
        return 'priorityDisplayMedium';
      case Priority.low:
        return 'priorityDisplayLow';
    }
  }

  // Changed return type to Color and used AppColors
  Color get color {
    switch (this) {
      case Priority.critical:
        return AppColors.priorityCriticalColor;
      case Priority.high:
        return AppColors.priorityHighColor;
      case Priority.medium:
        return AppColors.priorityMediumColor;
      case Priority.low:
        return AppColors.priorityLowColor;
    }
  }

  String toFormattedString() {
    return toString().split('.').last;
  }
}

class PriorityConverter {
  static Priority stringToPriority(String? priorityString) {
    final normalized = priorityString?.trim().toLowerCase();
    if (normalized == AppInternalConstants.priorityValueCritical) {
      return Priority.critical;
    } else if (normalized == AppInternalConstants.priorityValueHigh) {
      return Priority.high;
    } else if (normalized == AppInternalConstants.priorityValueMedium) {
      return Priority.medium;
    } else if (normalized == AppInternalConstants.priorityValueLow) {
      return Priority.low;
    } else {
      return Priority.medium;
    }
  }
}
