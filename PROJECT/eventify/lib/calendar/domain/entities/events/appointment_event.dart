import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/common/utils/priorities/priorities_enum.dart';

class AppointmentEvent extends Event {
  final String? withPerson;
  final bool withPersonYesNo;
  final String? location;

  AppointmentEvent({
    required super.title,
    super.description,
    required super.priority,
    super.date,
    super.time,
    super.hasNotification,
    required super.userId,
    this.withPerson,
    required this.withPersonYesNo,
    this.location,
  }) : super();

  factory AppointmentEvent.fromJson(Map<String, dynamic> json) {
    return AppointmentEvent(
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      priority: PriorityConverter.stringToPriority(json['priority']),
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time'],
      hasNotification: json['hasNotification'],
      withPerson: json['withPerson'],
      withPersonYesNo: json['withPersonYesNo'] ??
          false,
      location: json['location'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': 'appointment',
      'withPerson': withPerson,
      'withPersonYesNo': withPersonYesNo,
      'location': location,
       'priority': priority.toString(),
    };
  }
}