import 'package:flutter/widgets.dart';
import 'package:eventify/common/constants/app_strings.dart';

enum EventType { meeting, exam, appointment, conference, task, all }

extension EventTypeLocalization on EventType {
  String localizedName(BuildContext context) {
    switch (this) {
      case EventType.meeting:
        return AppStrings.searchEventTypeMeetingDisplay(context);
      case EventType.exam:
        return AppStrings.searchEventTypeExamDisplay(context);
      case EventType.appointment:
        return AppStrings.searchEventTypeAppointmentDisplay(context);
      case EventType.conference:
        return AppStrings.searchEventTypeConferenceDisplay(context);
      case EventType.task:
        return AppStrings.searchEventTypeTaskDisplay(context);
      case EventType.all:
        return AppStrings.searchEventTypeAllDisplay(context);
    }
  }
}
