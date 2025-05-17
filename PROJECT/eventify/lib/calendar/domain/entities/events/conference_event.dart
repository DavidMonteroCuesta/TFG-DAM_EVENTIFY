import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/common/utils/priorities/priorities_enum.dart';

class ConferenceEvent extends Event {
  final String? location;

  ConferenceEvent({
    required super.id,
    required super.title,
    super.description,
    required super.priority,
    super.date,
    super.time,
    super.hasNotification,
    required super.userId,
    this.location,
  }) : super();

  factory ConferenceEvent.fromJson(Map<String, dynamic> json) {
    return ConferenceEvent(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      priority: PriorityConverter.stringToPriority(json['priority']),
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time'],
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
       'priority': priority.toString(),
    };
  }
}