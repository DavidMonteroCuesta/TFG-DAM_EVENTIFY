import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:flutter/material.dart';

// Lógica para obtener los textos traducidos de tipo y prioridad para la tarjeta de evento próximo.
class UpcomingEventCardLogic {
  // Devuelve el texto traducido y en mayúsculas del tipo de evento.
  static String getTranslatedEventType(
    BuildContext context,
    String typeString,
  ) {
    switch (typeString.toLowerCase()) {
      case AppInternalConstants.eventTypeMeeting:
        return AppStrings.searchEventTypeMeetingDisplay(context).toUpperCase();
      case AppInternalConstants.eventTypeExam:
        return AppStrings.searchEventTypeExamDisplay(context).toUpperCase();
      case AppInternalConstants.eventTypeConference:
        return AppStrings.searchEventTypeConferenceDisplay(
          context,
        ).toUpperCase();
      case AppInternalConstants.eventTypeAppointment:
        return AppStrings.searchEventTypeAppointmentDisplay(
          context,
        ).toUpperCase();
      case AppInternalConstants.eventTypeTask:
      default:
        return AppStrings.searchEventTypeTaskDisplay(context).toUpperCase();
    }
  }

  // Devuelve el texto traducido de la prioridad del evento.
  static String getTranslatedPriority(
    BuildContext context,
    String priorityString,
  ) {
    switch (priorityString.toLowerCase()) {
      case AppInternalConstants.priorityValueCritical:
        return AppStrings.priorityDisplayCritical(context);
      case AppInternalConstants.priorityValueHigh:
        return AppStrings.priorityDisplayHigh(context);
      case AppInternalConstants.priorityValueMedium:
        return AppStrings.priorityDisplayMedium(context);
      case AppInternalConstants.priorityValueLow:
        return AppStrings.priorityDisplayLow(context);
      default:
        return priorityString;
    }
  }
}
