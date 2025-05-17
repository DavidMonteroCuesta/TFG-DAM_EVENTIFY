import 'package:eventify/common/utils/priorities/priorities_enum.dart';

class Event {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final Priority priority;
  final DateTime? date;
  final String? time;
  final bool? hasNotification;

  Event({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.priority,
    this.date,
    this.time,
    this.hasNotification,
  });

  // Added fromJson factory constructor to the Event class.
  factory Event.fromJson(Map<String, dynamic> json) {
    //  throw UnimplementedError("Cannot create raw Event from JSON, use a subclass.");
    // Improved error handling: We should provide a more informative error message
    // and potentially a way to handle this situation more gracefully.  For example,
    // we could log an error and return null, or return a default event.
    //
    // For now, I'll throw an error, as that's the safest option to prevent unexpected behavior.
    throw ArgumentError(
        'Event.fromJson: Cannot create instance of Event directly.  Use a specific subclass (e.g., MeetingEvent, TaskEvent).');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'priority': priority.toString(),
      'date': date?.toIso8601String(),
      'time': time,
      'hasNotification': hasNotification,
    };
  }
}