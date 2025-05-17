enum Priority { critical, high, medium, low }

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
        return Priority.medium; // Valor por defecto
    }
  }
}
