import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyCalendarLogic {
  static Set<DateTime> extractDatesWithEvents(
    List<Map<String, dynamic>> eventsData,
  ) {
    return eventsData.where((eventData) => eventData['dateTime'] != null).map((
      eventData,
    ) {
      final Timestamp eventTimestamp = eventData['dateTime'] as Timestamp;
      return DateTime(
        eventTimestamp.toDate().year,
        eventTimestamp.toDate().month,
        eventTimestamp.toDate().day,
      );
    }).toSet();
  }
}
