import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';

class Event {
  final String userId;
  final String title;
  final String? description;
  final Priority priority;
  final Timestamp? dateTime;
  final bool? hasNotification;

  Event({
    required this.userId,
    required this.title,
    this.description,
    required this.priority,
    this.dateTime,
    this.hasNotification,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    throw ArgumentError(
        'Event.fromJson: Cannot create instance of Event directly.  Use a specific subclass (e.g., MeetingEvent, TaskEvent).');
  }

  get type => null;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'priority': priority.toFormattedString(),
      'dateTime': dateTime,
      'hasNotification': hasNotification,
    };
  }
}