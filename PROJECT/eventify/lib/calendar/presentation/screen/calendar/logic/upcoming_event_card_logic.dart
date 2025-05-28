import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';

class UpcomingEventCardLogic {
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
