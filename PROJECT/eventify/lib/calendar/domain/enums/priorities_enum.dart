import 'package:eventify/common/constants/app_strings.dart'; // Import AppStrings

enum Priority {
  critical,
  high,
  medium,
  low,
}

extension PriorityExtension on Priority {
  String get name {
    switch (this) {
      case Priority.critical:
        return AppStrings.priorityDisplayCritical;
      case Priority.high:
        return AppStrings.priorityDisplayHigh;
      case Priority.medium:
        return AppStrings.priorityDisplayMedium;
      case Priority.low:
        return AppStrings.priorityDisplayLow;
    }
  }

  String get color {
    switch (this) {
      case Priority.critical:
        return '#FF0000'; // Red
      case Priority.high:
        return '#FFA500'; // Orange
      case Priority.medium:
        return '#FFFF00'; // Yellow
      case Priority.low:
        return '#008000'; // Green
    }
  }

  String toFormattedString() {
    return name.toLowerCase();
  }
}

class PriorityConverter {
  static Priority stringToPriority(String? priorityString) {
    final normalized = priorityString?.trim().toLowerCase();
    if (normalized == AppStrings.priorityValueCritical) {
      return Priority.critical;
    } else if (normalized == AppStrings.priorityValueHigh) {
      return Priority.high;
    } else if (normalized == AppStrings.priorityValueMedium) {
      return Priority.medium;
    } else if (normalized == AppStrings.priorityValueLow) {
      return Priority.low;
    } else {
      return Priority.medium;
    }
  }
}