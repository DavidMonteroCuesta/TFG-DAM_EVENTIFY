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
      log('Evento añadido a Firestore para el usuario: $userId', name: _tag);
    } catch (e) {
      log('Error al añadir evento a Firestore: $e', name: _tag, error: e);
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
          .doc(eventId)
          .update(eventData);
      log('Evento actualizado en Firestore para el usuario: $userId y evento: $eventId',
          name: _tag);
    } catch (e) {
      log('Error al actualizar evento en Firestore: $e', name: _tag, error: e);
      rethrow;
    }
  }

  Future<void> deleteEvent(String userId, String eventId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .delete();
      log('Evento borrado de Firestore para el usuario: $userId y evento: $eventId',
          name: _tag);
    } catch (e) {
      log('Error al borrar evento de Firestore: $e', name: _tag, error: e);
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
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log('Error al obtener eventos de Firestore para el usuario: $userId',
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
          .orderBy('dateTime') // Order by dateTime
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      Timestamp now = Timestamp.now();
      for (final doc in snapshot.docs) {
        final eventData = doc.data();
        final Timestamp? eventDateTime = eventData['dateTime']; // Get the Timestamp

        if (eventDateTime != null &&
            (eventDateTime.compareTo(now) >=
                0)) { // Compare Timestamps using compareTo
          return eventData;
        }
      }
      return null;
    } catch (e) {
      log('Error while fetching the nearest event from Firestore for user: $userId',
          name: _tag, error: e);
      rethrow;
    }
  }
}

