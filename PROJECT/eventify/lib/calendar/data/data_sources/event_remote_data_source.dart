import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';
import 'package:eventify/common/constants/app_logs.dart';

class EventRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _tag = 'EventRemoteDataSource';

  Future<String> addEvent(String userId, Map<String, dynamic> eventData) async {
    try {
      final DocumentReference docRef = await _firestore
          .collection(AppFirestoreFields.users)
          .doc(userId)
          .collection(AppFirestoreFields.events)
          .add(eventData);
      log(
        '${AppLogs.eventAdded} $userId ${AppLogs.withId} ${docRef.id}',
        name: _tag,
      );
      return docRef.id;
    } catch (e) {
      log(AppLogs.eventAddError + e.toString(), name: _tag, error: e);
      rethrow;
    }
  }

  Future<void> updateEvent(
    String userId,
    String eventId,
    Map<String, dynamic> eventData,
  ) async {
    try {
      await _firestore
          .collection(AppFirestoreFields.users)
          .doc(userId)
          .collection(AppFirestoreFields.events)
          .doc(eventId)
          .update(eventData);
      log(
        '${AppLogs.eventUpdated} $userId ${AppLogs.andEvent} $eventId',
        name: _tag,
      );
    } catch (e) {
      log(AppLogs.eventUpdateError + e.toString(), name: _tag, error: e);
      rethrow;
    }
  }

  Future<void> deleteEvent(String userId, String eventId) async {
    try {
      await _firestore
          .collection(AppFirestoreFields.users)
          .doc(userId)
          .collection(AppFirestoreFields.events)
          .doc(eventId)
          .delete();
      log(
        '${AppLogs.eventDeleted} $userId ${AppLogs.andEvent} $eventId',
        name: _tag,
      );
    } catch (e) {
      log(AppLogs.eventDeleteError + e.toString(), name: _tag, error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForUser(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection(AppFirestoreFields.users)
              .doc(userId)
              .collection(AppFirestoreFields.events)
              .get();
      return snapshot.docs
          .map((doc) => {...doc.data(), AppFirestoreFields.id: doc.id})
          .toList();
    } catch (e) {
      log(AppLogs.eventFetchError + userId, name: _tag, error: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getNearestEventForUser(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection(AppFirestoreFields.users)
              .doc(userId)
              .collection(AppFirestoreFields.events)
              .orderBy(AppFirestoreFields.dateTime)
              .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      Timestamp now = Timestamp.now();
      for (final doc in snapshot.docs) {
        final eventData = doc.data();
        final Timestamp? eventDateTime = eventData[AppFirestoreFields.dateTime];

        if (eventDateTime != null && (eventDateTime.compareTo(now) >= 0)) {
          return {...eventData, AppFirestoreFields.id: doc.id};
        }
      }
      return null;
    } catch (e) {
      log(AppLogs.eventFetchNearestError + userId, name: _tag, error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForUserAndMonth(
    String userId,
    int year,
    int month,
  ) async {
    try {
      final DateTime startOfMonth = DateTime(year, month, 1);
      final DateTime endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);

      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection(AppFirestoreFields.users)
              .doc(userId)
              .collection(AppFirestoreFields.events)
              .where(
                AppFirestoreFields.dateTime,
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
              )
              .where(
                AppFirestoreFields.dateTime,
                isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth),
              )
              .get();
      return snapshot.docs
          .map((doc) => {...doc.data(), AppFirestoreFields.id: doc.id})
          .toList();
    } catch (e) {
      log(AppLogs.eventFetchByMonthError + e.toString(), name: _tag, error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForUserAndYear(
    String userId,
    int year,
  ) async {
    try {
      const int startMonth = 1;
      const int startDay = 1;
      const int endMonth = 12;
      const int endDay = 31;
      const int endHour = 23;
      const int endMinute = 59;
      const int endSecond = 59;

      // Define el rango de fechas para el año solicitado
      final DateTime startOfYear = DateTime(year, startMonth, startDay);
      final DateTime endOfYear = DateTime(
        year,
        endMonth,
        endDay,
        endHour,
        endMinute,
        endSecond,
      );

      // Consulta los eventos del usuario en el rango de fechas
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection(AppFirestoreFields.users)
              .doc(userId)
              .collection(AppFirestoreFields.events)
              .where(
                AppFirestoreFields.dateTime,
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear),
              )
              .where(
                AppFirestoreFields.dateTime,
                isLessThanOrEqualTo: Timestamp.fromDate(endOfYear),
              )
              .get();
      log(
        // Log de la consulta realizada
        '${AppLogs.eventFetchByYear} $year ${AppLogs.forUser} $userId: ${AppLogs.count} ${snapshot.docs.length}',
        name: _tag,
      );
      // Devuelve la lista de eventos con el id incluido
      return snapshot.docs
          .map((doc) => {...doc.data(), AppFirestoreFields.id: doc.id})
          .toList();
    } catch (e) {
      // Log de error en caso de fallo
      log(AppLogs.eventFetchByYearError + e.toString(), name: _tag, error: e);
      rethrow;
    }
  }
}
