import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/events/appointment_event.dart';
import 'package:eventify/calendar/domain/entities/events/conference_event.dart';
import 'package:eventify/calendar/domain/entities/events/exam_event.dart';
import 'package:eventify/calendar/domain/entities/events/meeting_event.dart';
import 'package:eventify/calendar/domain/entities/events/task_event.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';

class EventFactory {
  static Event createEvent(EventType type, Map<String, dynamic> json, String userId) {
    final String eventTypeString = json['type'] ?? 'task';
    final Priority priority = PriorityConverter.stringToPriority(json['priority']);

    switch (eventTypeString) {
      case 'meeting':
        return MeetingEvent(
          userId: userId,
          title: json['title'] ?? '',
          description: json['description'],
          priority: priority,
          dateTime: json['dateTime'],
          hasNotification: json['hasNotification'],
          location: json['location'],
        );
      case 'exam':
        return ExamEvent(
          userId: userId,
          title: json['title'] ?? '',
          description: json['description'],
          priority: priority,
          dateTime: json['dateTime'],
          hasNotification: json['hasNotification'],
          subject: json['subject'],
        );
      case 'conference':
        return ConferenceEvent(
          userId: userId,
          title: json['title'] ?? '',
          description: json['description'],
          priority: priority,
          dateTime: json['dateTime'],
          hasNotification: json['hasNotification'],
          location: json['location'],
        );
      case 'appointment':
        return AppointmentEvent(
          userId: userId,
          title: json['title'] ?? '',
          description: json['description'],
          priority: priority,
          dateTime: json['dateTime'],
          hasNotification: json['hasNotification'],
          location: json['location'],
          withPerson: json['withPerson'],
          withPersonYesNo: json['withPersonYesNo'] ?? false,
        );
      case 'task':
      default:
        return TaskEvent(
          userId: userId,
          title: json['title'] ?? '',
          description: json['description'],
          priority: priority,
          dateTime: json['dateTime'],
          hasNotification: json['hasNotification'],
        );
    }
  }
}
