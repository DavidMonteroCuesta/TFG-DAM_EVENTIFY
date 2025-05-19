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
        return 'Critical';
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
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
    switch (normalized) {
      case 'critical':
        return Priority.critical;
      case 'high':
        return Priority.high;
      case 'medium':
        return Priority.medium;
      case 'low':
        return Priority.low;
      default:
        return Priority.medium;
    }
  }
}
