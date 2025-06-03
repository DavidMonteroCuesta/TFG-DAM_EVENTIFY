import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:flutter/material.dart';

class EventTypeLogic {
  static EventType getEventTypeFromString(String typeString) {
    // Devuelve el tipo de evento correspondiente al string recibido.
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
        return EventType.task;
      default:
        return EventType.all;
    }
  }

  static String getTranslatedEventTypeDisplay(
    EventType type,
    BuildContext context,
  ) {
    // Devuelve el texto traducido del tipo de evento.
    switch (type) {
      case EventType.meeting:
        return AppStrings.searchEventTypeMeetingDisplay(context);
      case EventType.exam:
        return AppStrings.searchEventTypeExamDisplay(context);
      case EventType.conference:
        return AppStrings.searchEventTypeConferenceDisplay(context);
      case EventType.appointment:
        return AppStrings.searchEventTypeAppointmentDisplay(context);
      case EventType.task:
        return AppStrings.searchEventTypeTaskDisplay(context);
      case EventType.all:
        return AppStrings.searchEventTypeAllDisplay(context);
    }
  }
}
