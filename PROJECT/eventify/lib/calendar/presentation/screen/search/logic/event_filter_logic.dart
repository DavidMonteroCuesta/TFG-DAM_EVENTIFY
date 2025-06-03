import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

/// Lógica para filtrar eventos según los criterios de búsqueda seleccionados.
class EventFilterLogic {
  /// Aplica los filtros de búsqueda sobre la lista de eventos.
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
    results = _filterByTitle(results, title);
    results = _filterByDescription(results, description);
    results = _filterByDate(results, selectedSearchDate);
    results = _filterByEventType(results, selectedEventType);
    results = _filterByPriority(
      results,
      enablePriorityFilter,
      selectedPriority,
    );
    results = _filterByLocation(results, selectedEventType, location);
    results = _filterBySubject(results, selectedEventType, subject);
    results = _filterByWithPerson(
      results,
      selectedEventType,
      withPersonYesNoSearch,
      withPerson,
    );
    return results;
  }

  // Filtra por título
  static List<Map<String, dynamic>> _filterByTitle(
    List<Map<String, dynamic>> events,
    String title,
  ) {
    if (title.isEmpty) return events;
    return events
        .where(
          (eventData) =>
              (eventData[AppFirestoreFields.title] as String?)
                  ?.toLowerCase()
                  .contains(title) ??
              false,
        )
        .toList();
  }

  // Filtra por descripción
  static List<Map<String, dynamic>> _filterByDescription(
    List<Map<String, dynamic>> events,
    String description,
  ) {
    if (description.isEmpty) return events;
    return events
        .where(
          (eventData) =>
              (eventData[AppFirestoreFields.description] as String?)
                  ?.toLowerCase()
                  .contains(description) ??
              false,
        )
        .toList();
  }

  // Filtra por fecha
  static List<Map<String, dynamic>> _filterByDate(
    List<Map<String, dynamic>> events,
    DateTime? selectedSearchDate,
  ) {
    if (selectedSearchDate == null) return events;
    return events.where((eventData) {
      final Timestamp? eventTimestamp = eventData[AppFirestoreFields.dateTime];
      if (eventTimestamp != null) {
        final date = eventTimestamp.toDate();
        return date.year == selectedSearchDate.year &&
            date.month == selectedSearchDate.month &&
            date.day == selectedSearchDate.day;
      }
      return false;
    }).toList();
  }

  // Filtra por tipo de evento
  static List<Map<String, dynamic>> _filterByEventType(
    List<Map<String, dynamic>> events,
    EventType selectedEventType,
  ) {
    if (selectedEventType == EventType.all) return events;
    return events.where((eventData) {
      final eventTypeString = eventData[AppFirestoreFields.type] as String?;
      if (eventTypeString == null) return false;
      return eventTypeString == selectedEventType.name;
    }).toList();
  }

  // Filtra por prioridad
  static List<Map<String, dynamic>> _filterByPriority(
    List<Map<String, dynamic>> events,
    bool enablePriorityFilter,
    Priority? selectedPriority,
  ) {
    if (!enablePriorityFilter || selectedPriority == null) return events;
    return events.where((eventData) {
      final priorityString = eventData[AppFirestoreFields.priority] as String?;
      if (priorityString == null) return false;
      return PriorityConverter.stringToPriority(priorityString) ==
          selectedPriority;
    }).toList();
  }

  // Filtra por ubicación
  static List<Map<String, dynamic>> _filterByLocation(
    List<Map<String, dynamic>> events,
    EventType selectedEventType,
    String location,
  ) {
    if (!(selectedEventType == EventType.meeting ||
            selectedEventType == EventType.conference ||
            selectedEventType == EventType.appointment ||
            selectedEventType == EventType.all) ||
        location.isEmpty) {
      return events;
    }
    return events.where((eventData) {
      final eventTypeString = eventData[AppFirestoreFields.type] as String?;
      if (eventTypeString == AppFirestoreFields.typeMeeting ||
          eventTypeString == AppFirestoreFields.typeConference ||
          eventTypeString == AppFirestoreFields.typeAppointment) {
        return (eventData[AppFirestoreFields.location] as String?)
                ?.toLowerCase()
                .contains(location) ??
            false;
      }
      return false;
    }).toList();
  }

  // Filtra por asignatura
  static List<Map<String, dynamic>> _filterBySubject(
    List<Map<String, dynamic>> events,
    EventType selectedEventType,
    String subject,
  ) {
    if (!(selectedEventType == EventType.exam ||
            selectedEventType == EventType.all) ||
        subject.isEmpty) {
      return events;
    }
    return events.where((eventData) {
      final eventTypeString = eventData[AppFirestoreFields.type] as String?;
      if (eventTypeString == AppFirestoreFields.typeExam) {
        return (eventData[AppFirestoreFields.subject] as String?)
                ?.toLowerCase()
                .contains(subject) ??
            false;
      }
      return false;
    }).toList();
  }

  // Filtra por acompañante
  static List<Map<String, dynamic>> _filterByWithPerson(
    List<Map<String, dynamic>> events,
    EventType selectedEventType,
    bool withPersonYesNoSearch,
    String withPerson,
  ) {
    if (!(selectedEventType == EventType.appointment ||
            selectedEventType == EventType.all) ||
        !withPersonYesNoSearch) {
      return events;
    }
    return events.where((eventData) {
      final eventTypeString = eventData[AppFirestoreFields.type] as String?;
      if (eventTypeString == AppFirestoreFields.typeAppointment) {
        final bool withPersonYesNo =
            eventData[AppFirestoreFields.withPersonYesNo] ?? false;
        final String? eventWithPerson =
            eventData[AppFirestoreFields.withPerson];
        return withPersonYesNo &&
            (eventWithPerson?.toLowerCase().contains(withPerson) ?? false);
      }
      return false;
    }).toList();
  }
}
