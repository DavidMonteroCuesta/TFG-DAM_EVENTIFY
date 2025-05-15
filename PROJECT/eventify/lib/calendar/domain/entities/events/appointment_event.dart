import 'package:eventify/calendar/domain/entities/event.dart';

class AppointmentEvent extends Event {
  final String? withPerson;
  final bool withPersonYesNo;
  final String? location;

  AppointmentEvent({
    required super.id,
    required super.title,
    super.description,
    required super.priority,
    super.date,
    super.time,
    super.hasNotification,
    required super.userId,
    this.withPerson,
    this.withPersonYesNo = false,
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
      'type': 'Appointment',
      'withPerson': withPerson,
      'withPersonYesNo': withPersonYesNo,
      'location': location,
    };
  }
}