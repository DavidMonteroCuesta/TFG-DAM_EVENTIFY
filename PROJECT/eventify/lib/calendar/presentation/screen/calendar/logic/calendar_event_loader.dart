import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';
import 'package:eventify/common/constants/app_logs.dart';

// Lógica para cargar los conteos de eventos mensuales de un usuario en el calendario.
class CalendarEventLoader {
  static const int _firstMonth = 1;
  static const int _lastMonth = 12;
  static const int _eventIncrement = 1;
  static const int _initialEventCount = 0;

  // Carga y devuelve un mapa con el número de eventos por mes para el año dado.
  static Future<Map<int, int>> loadMonthlyEventCounts(
    EventViewModel eventViewModel,
    int yearToLoad,
  ) async {
    Map<int, int> counts = {
      for (var i = _firstMonth; i <= _lastMonth; i++) i: _initialEventCount,
    };
    try {
      await eventViewModel.getEventsForCurrentUserAndYear(yearToLoad);
      final List<Map<String, dynamic>> allEventsForYear = eventViewModel.events;
      for (final eventData in allEventsForYear) {
        final Timestamp? eventTimestamp =
            eventData[AppFirestoreFields.dateTime];
        if (eventTimestamp != null) {
          final int month = eventTimestamp.toDate().month;
          counts[month] = (counts[month] ?? 0) + _eventIncrement;
        }
      }
    } catch (e) {
      log('${AppLogs.calendarErrorLoadingMonthlyCounts}$yearToLoad: $e');
    }
    return counts;
  }
}
