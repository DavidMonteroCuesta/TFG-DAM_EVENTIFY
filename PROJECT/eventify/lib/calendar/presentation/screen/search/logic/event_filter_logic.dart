import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';

class EventFilterLogic {
  static List<Map<String, dynamic>> filterEvents({
    required List<Map<String, dynamic>> allEventsData,
    required String title,
    required String description,
    required String location,
    required String subject,
    required String withPerson,
    required DateTime? selectedSearchDate,
    required EventType selectedEventType,
    required bool enablePriorityFilter,
    required Priority? selectedPriority,
    required bool withPersonYesNoSearch,
    required String eventTypeMeeting,
    required String eventTypeConference,
    required String eventTypeAppointment,
    required String eventTypeExam,
  }) {
    List<Map<String, dynamic>> results = List.from(allEventsData);
    if (title.isNotEmpty) {
      results =
          results
              .where(
                (eventData) =>
                    (eventData['title'] as String?)?.toLowerCase().contains(
                      title,
                    ) ??
                    false,
              )
              .toList();
    }
    if (description.isNotEmpty) {
      results =
          results
              .where(
                (eventData) =>
                    (eventData['description'] as String?)
                        ?.toLowerCase()
                        .contains(description) ??
                    false,
              )
              .toList();
    }
    if (selectedSearchDate != null) {
      results =
          results.where((eventData) {
            final Timestamp? eventTimestamp = eventData['dateTime'];
            if (eventTimestamp != null) {
              final date = eventTimestamp.toDate();
              return date.year == selectedSearchDate.year &&
                  date.month == selectedSearchDate.month &&
                  date.day == selectedSearchDate.day;
            }
            return false;
          }).toList();
    }
    if (selectedEventType != EventType.all) {
      results =
          results.where((eventData) {
            final eventTypeString = eventData['type'] as String?;
            if (eventTypeString == null) return false;
            return eventTypeString == selectedEventType.name;
          }).toList();
    }
    if (enablePriorityFilter && selectedPriority != null) {
      results =
          results.where((eventData) {
            final priorityString = eventData['priority'] as String?;
            if (priorityString == null) return false;
            return PriorityConverter.stringToPriority(priorityString) ==
                selectedPriority;
          }).toList();
    }
    if ((selectedEventType == EventType.meeting ||
            selectedEventType == EventType.conference ||
            selectedEventType == EventType.appointment ||
            selectedEventType == EventType.all) &&
        location.isNotEmpty) {
      results =
          results.where((eventData) {
            final eventTypeString = eventData['type'] as String?;
            if (eventTypeString == eventTypeMeeting ||
                eventTypeString == eventTypeConference ||
                eventTypeString == eventTypeAppointment) {
              return (eventData['location'] as String?)?.toLowerCase().contains(
                    location,
                  ) ??
                  false;
            }
            return false;
          }).toList();
    }
    if ((selectedEventType == EventType.exam ||
            selectedEventType == EventType.all) &&
        subject.isNotEmpty) {
      results =
          results.where((eventData) {
            final eventTypeString = eventData['type'] as String?;
            if (eventTypeString == eventTypeExam) {
              return (eventData['subject'] as String?)?.toLowerCase().contains(
                    subject,
                  ) ??
                  false;
            }
            return false;
          }).toList();
    }
    if ((selectedEventType == EventType.appointment ||
            selectedEventType == EventType.all) &&
        withPersonYesNoSearch) {
      results =
          results.where((eventData) {
            final eventTypeString = eventData['type'] as String?;
            if (eventTypeString == eventTypeAppointment) {
              final bool withPersonYesNo =
                  eventData['withPersonYesNo'] ?? false;
              final String? eventWithPerson = eventData['withPerson'];
              return withPersonYesNo &&
                  (eventWithPerson?.toLowerCase().contains(withPerson) ??
                      false);
            }
            return false;
          }).toList();
    }
    return results;
  }
}
