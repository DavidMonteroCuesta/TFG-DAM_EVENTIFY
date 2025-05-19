import 'package:eventify/calendar/domain/enums/priorities_enum.dart';

class Event {
  final String userId;
  final String title;
  final String? description;
  final Priority priority;
  final DateTime? date;
  final String? time;
  final bool? hasNotification;

  Event({
    required this.userId,
    required this.title,
    this.description,
    required this.priority,
    this.date,
    this.time,
    this.hasNotification,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    throw ArgumentError(
        'Event.fromJson: Cannot create instance of Event directly.  Use a specific subclass (e.g., MeetingEvent, TaskEvent).');
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'priority': priority.toFormattedString(),
      'date': date?.toIso8601String(),
      'time': time,
      'hasNotification': hasNotification,
    };
  }
}