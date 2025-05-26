import 'package:eventify/common/constants/app_internal_constants.dart';

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