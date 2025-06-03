import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

/// Lógica para extraer los días del mes que tienen eventos asociados.
class MonthlyCalendarLogic {
  /// Devuelve un conjunto de fechas que tienen eventos en el mes.
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
