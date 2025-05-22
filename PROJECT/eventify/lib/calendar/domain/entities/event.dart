import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';

abstract class Event {
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

  // *** CORRECCIÓN CLAVE AQUÍ: 'type' debe ser un getter abstracto ***
  String get type;

  // Factory constructor to create an Event from JSON (must be implemented by subclasses).
  // This factory will receive a Map<String, dynamic> that *includes* the Firestore 'id',
  // although the Event entity itself does not store it as a field.
  factory Event.fromJson(Map<String, dynamic> json) {
    throw ArgumentError(
        'Event.fromJson: Cannot create instance of Event directly. Use a specific subclass (e.g., MeetingEvent, TaskEvent).');
  }

  // Base toJson method to be extended by subclasses.
  // 'id' is NOT included here, as it is managed by Firestore.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'priority': priority.toFormattedString(), // Ensure priority is stored as string
      'dateTime': dateTime,
      'hasNotification': hasNotification,
      'type': type, // Include type in toJson
    };
  }

  // Optional getters for specific properties if needed for type conversion outside fromJson
  String? get location => null;
  String? get subject => null;
  String? get withPerson => null;
  bool get withPersonYesNo => false;
}
