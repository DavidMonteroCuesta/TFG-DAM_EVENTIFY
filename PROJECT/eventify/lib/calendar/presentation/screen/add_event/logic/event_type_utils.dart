import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';

EventType getEventTypeFromString(String typeString) {
  switch (typeString.toLowerCase()) {
    case AppInternalConstants.eventTypeMeeting:
      return EventType.meeting;
    case AppInternalConstants.eventTypeExam:
      return EventType.exam;
    case AppInternalConstants.eventTypeConference:
      return EventType.conference;
    case AppInternalConstants.eventTypeAppointment:
      return EventType.appointment;
    case AppInternalConstants.eventTypeTask:
    default:
      return EventType.task;
  }
}
