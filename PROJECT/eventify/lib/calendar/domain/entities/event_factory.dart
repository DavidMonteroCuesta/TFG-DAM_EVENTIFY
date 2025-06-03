import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/events/appointment_event.dart';
import 'package:eventify/calendar/domain/entities/events/conference_event.dart';
import 'package:eventify/calendar/domain/entities/events/exam_event.dart';
import 'package:eventify/calendar/domain/entities/events/meeting_event.dart';
import 'package:eventify/calendar/domain/entities/events/task_event.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

// Fábrica para crear instancias de eventos según el tipo y los datos recibidos
class EventFactory {
  static Event createEvent(
    EventType type,
    Map<String, dynamic> json,
    String userId,
  ) {
    final String eventTypeString =
        json[AppFirestoreFields.type] ?? AppFirestoreFields.typeTask;
    final Priority priority = PriorityConverter.stringToPriority(
      json[AppFirestoreFields.priority],
    );

    // Selecciona el tipo de evento y crea la instancia correspondiente
    switch (eventTypeString) {
      case AppFirestoreFields.typeMeeting:
        // Crea un MeetingEvent a partir del JSON
        return MeetingEvent(
          userId: userId,
          title: json[AppFirestoreFields.title] ?? '',
          description: json[AppFirestoreFields.description],
          priority: priority,
          dateTime: json[AppFirestoreFields.dateTime],
          hasNotification: json[AppFirestoreFields.notification],
          location: json[AppFirestoreFields.location],
        );
      case AppFirestoreFields.typeExam:
        // Crea un ExamEvent a partir del JSON
        return ExamEvent(
          userId: userId,
          title: json[AppFirestoreFields.title] ?? '',
          description: json[AppFirestoreFields.description],
          priority: priority,
          dateTime: json[AppFirestoreFields.dateTime],
          hasNotification: json[AppFirestoreFields.notification],
          subject: json[AppFirestoreFields.subject],
        );
      case AppFirestoreFields.typeConference:
        // Crea un ConferenceEvent a partir del JSON
        return ConferenceEvent(
          userId: userId,
          title: json[AppFirestoreFields.title] ?? '',
          description: json[AppFirestoreFields.description],
          priority: priority,
          dateTime: json[AppFirestoreFields.dateTime],
          hasNotification: json[AppFirestoreFields.notification],
          location: json[AppFirestoreFields.location],
        );
      case AppFirestoreFields.typeAppointment:
        // Crea un AppointmentEvent a partir del JSON
        return AppointmentEvent(
          userId: userId,
          title: json[AppFirestoreFields.title] ?? '',
          description: json[AppFirestoreFields.description],
          priority: priority,
          dateTime: json[AppFirestoreFields.dateTime],
          hasNotification: json[AppFirestoreFields.notification],
          location: json[AppFirestoreFields.location],
          withPerson: json[AppFirestoreFields.withPerson],
          withPersonYesNo: json[AppFirestoreFields.withPersonYesNo] ?? false,
        );
      case AppFirestoreFields.typeTask:
      default:
        // Crea un TaskEvent por defecto si el tipo no coincide
        return TaskEvent(
          userId: userId,
          title: json[AppFirestoreFields.title] ?? '',
          description: json[AppFirestoreFields.description],
          priority: priority,
          dateTime: json[AppFirestoreFields.dateTime],
          hasNotification: json[AppFirestoreFields.notification],
        );
    }
  }
}
