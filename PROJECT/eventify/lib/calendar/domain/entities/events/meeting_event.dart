import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/common/utils/priorities/priorities_enum.dart';

class MeetingEvent extends Event {
  final String? location;

  MeetingEvent({
    required super.title,
    super.description,
    required super.priority,
    super.date,
    super.time,
    super.hasNotification,
    required super.userId,
    this.location,
  }) : super();

  factory MeetingEvent.fromJson(Map<String, dynamic> json) {
    return MeetingEvent(
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      priority:
          PriorityConverter.stringToPriority(json['priority']),
      date: json['date'] != null
          ? DateTime.tryParse(json['date'])
          : null, // Use tryParse
      time: json['time'],
      hasNotification: json['hasNotification'],
      location: json['location'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': 'meeting', // Add the type discriminator.
      'location': location,
      'priority': priority.toString(), // Include priority here
    };
  }
}