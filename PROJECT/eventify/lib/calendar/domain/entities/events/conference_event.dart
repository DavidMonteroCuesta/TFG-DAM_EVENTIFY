import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';

class ConferenceEvent extends Event {
  final String? location;

  ConferenceEvent({
    required super.title,
    super.description,
    required super.priority,
    super.dateTime,
    super.hasNotification,
    required super.userId,
    this.location,
  }) : super();

  factory ConferenceEvent.fromJson(Map<String, dynamic> json) {
    return ConferenceEvent(
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      priority: PriorityConverter.stringToPriority(json['priority']),
      dateTime: json['dateTime'],
      hasNotification: json['hasNotification'],
      location: json['location'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': 'conference',
      'location': location,
      'priority': priority.toFormattedString(),
    };
  }
}