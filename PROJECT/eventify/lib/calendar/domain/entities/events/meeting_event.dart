import 'package:eventify/calendar/domain/entities/event.dart';

class MeetingEvent extends Event {
  final String? location;

  MeetingEvent({
    required super.id,
    required super.title,
    super.description,
    required super.priority,
    super.date,
    super.time, // Usamos String
    super.hasNotification,
    required super.userId,
    this.location,
  });

  @override
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
      'type': 'Meeting',
      'location': location,
    };
  }
}