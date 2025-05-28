import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:eventify/common/constants/app_logs.dart';

class EventRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _tag = 'EventRemoteDataSource';

  Future<String> addEvent(String userId, Map<String, dynamic> eventData) async {
    try {
      final DocumentReference docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .add(eventData);
      log(
        AppLogs.eventAdded +
            ' ' +
            userId +
            ' ' +
            AppLogs.withId +
            ' ' +
            docRef.id,
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
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .update(eventData);
      log(
        AppLogs.eventUpdated +
            ' ' +
            userId +
            ' ' +
            AppLogs.andEvent +
            ' ' +
            eventId,
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
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId) // Use the eventId to target the specific document
          .delete();
      log(
        AppLogs.eventDeleted +
            ' ' +
            userId +
            ' ' +
            AppLogs.andEvent +
            ' ' +
            eventId,
        name: _tag,
      );
    } catch (e) {
      log(AppLogs.eventDeleteError + e.toString(), name: _tag, error: e);
      rethrow;
    }
  }

  // Always includes the document ID in the returned maps
  Future<List<Map<String, dynamic>>> getEventsForUser(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('events')
              .get();
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      log(AppLogs.eventFetchError + userId, name: _tag, error: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getNearestEventForUser(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('events')
              .orderBy('dateTime')
              .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      Timestamp now = Timestamp.now();
      for (final doc in snapshot.docs) {
        final eventData = doc.data();
        final Timestamp? eventDateTime = eventData['dateTime'];

        if (eventDateTime != null && (eventDateTime.compareTo(now) >= 0)) {
          return {...eventData, 'id': doc.id};
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
              .collection('users')
              .doc(userId)
              .collection('events')
              .where(
                'dateTime',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
              )
              .where(
                'dateTime',
                isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth),
              )
              .get();
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
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
      final DateTime startOfYear = DateTime(year, 1, 1);
      final DateTime endOfYear = DateTime(year, 12, 31, 23, 59, 59);

      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('events')
              .where(
                'dateTime',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear),
              )
              .where(
                'dateTime',
                isLessThanOrEqualTo: Timestamp.fromDate(endOfYear),
              )
              .get();
      log(
        AppLogs.eventFetchByYear +
            ' ' +
            year.toString() +
            ' ' +
            AppLogs.forUser +
            ' ' +
            userId +
            ': ' +
            AppLogs.count +
            ' ' +
            snapshot.docs.length.toString(),
        name: _tag,
      );
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      log(AppLogs.eventFetchByYearError + e.toString(), name: _tag, error: e);
      rethrow;
    }
  }
}
