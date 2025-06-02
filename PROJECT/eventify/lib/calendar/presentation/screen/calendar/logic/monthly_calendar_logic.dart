import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

class MonthlyCalendarLogic {
  static Set<DateTime> extractDatesWithEvents(
    List<Map<String, dynamic>> eventsData,
  ) {
    return eventsData
        .where((eventData) => eventData[AppFirestoreFields.dateTime] != null)
        .map((eventData) {
          final Timestamp eventTimestamp =
              eventData[AppFirestoreFields.dateTime] as Timestamp;
          return DateTime(
            eventTimestamp.toDate().year,
            eventTimestamp.toDate().month,
            eventTimestamp.toDate().day,
          );
        })
        .toSet();
  }
}
