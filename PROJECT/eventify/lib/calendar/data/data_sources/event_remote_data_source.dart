import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class EventRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _tag = 'EventRemoteDataSource';

  Future<void> addEvent(String userId, Map<String, dynamic> eventData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .add(eventData);
      log('Event added to Firestore for user: $userId', name: _tag);
    } catch (e) {
      log('Error adding event to Firestore: $e', name: _tag, error: e);
      rethrow;
    }
  }

  Future<void> updateEvent(
      String userId, String eventId, Map<String, dynamic> eventData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId) // Use the eventId to target the specific document
          .update(eventData);
      log('Event updated in Firestore for user: $userId and event: $eventId',
          name: _tag);
    } catch (e) {
      log('Error updating event in Firestore: $e', name: _tag, error: e);
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
      log('Event deleted from Firestore for user: $userId and event: $eventId',
          name: _tag);
    } catch (e) {
      log('Error deleting event from Firestore: $e', name: _tag, error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForUser(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .get();
      // Include the document ID in the returned data, as it's needed for update/delete
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      log('Error fetching events from Firestore for user: $userId',
          name: _tag, error: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getNearestEventForUser(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
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

        if (eventDateTime != null &&
            (eventDateTime.compareTo(now) >= 0)) {
          return {...eventData, 'id': doc.id}; // Include ID for nearest event
        }
      }
      return null;
    } catch (e) {
      log('Error while fetching the nearest event from Firestore for user: $userId',
          name: _tag, error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForUserAndMonth(String userId, int year, int month) async {
    try {
      final DateTime startOfMonth = DateTime(year, month, 1);
      final DateTime endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);

      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList(); // Include ID
    } catch (e) {
      log('Error fetching events by user and month from Firestore: $e', name: _tag, error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForUserAndYear(String userId, int year) async {
    try {
      final DateTime startOfYear = DateTime(year, 1, 1);
      final DateTime endOfYear = DateTime(year, 12, 31, 23, 59, 59);

      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfYear))
          .get();
      log('Events fetched for year $year for user $userId: ${snapshot.docs.length}', name: _tag);
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList(); // Include ID
    } catch (e) {
      log('Error fetching events by user and year from Firestore: $e', name: _tag, error: e);
      rethrow;
    }
  }
}