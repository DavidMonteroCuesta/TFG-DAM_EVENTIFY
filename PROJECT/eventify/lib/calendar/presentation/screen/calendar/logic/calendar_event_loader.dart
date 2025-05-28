import 'dart:developer';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/common/constants/app_logs.dart';

class CalendarEventLoader {
  static Future<Map<int, int>> loadMonthlyEventCounts(
    EventViewModel eventViewModel,
    int yearToLoad,
  ) async {
    Map<int, int> counts = {for (var i = 1; i <= 12; i++) i: 0};
    try {
      await eventViewModel.getEventsForCurrentUserAndYear(yearToLoad);
      final List<Map<String, dynamic>> allEventsForYear = eventViewModel.events;
      for (final eventData in allEventsForYear) {
        final Timestamp? eventTimestamp = eventData['dateTime'];
        if (eventTimestamp != null) {
          final int month = eventTimestamp.toDate().month;
          counts[month] = (counts[month] ?? 0) + 1;
        }
      }
    } catch (e) {
      log(
        AppLogs.calendarErrorLoadingMonthlyCounts +
            yearToLoad.toString() +
            ': ' +
            e.toString(),
      );
    }
    return counts;
  }
}
