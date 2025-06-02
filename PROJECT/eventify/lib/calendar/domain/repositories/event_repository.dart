import 'package:eventify/calendar/domain/entities/event.dart';

abstract class EventRepository {
  Future<String> addEvent(String userId, Event event);
  Future<void> updateEvent(String userId, String eventId, Event event);
  Future<void> deleteEvent(String userId, String eventId);
  Future<List<Map<String, dynamic>>> getEventsForUser(String userId);
  Future<Map<String, dynamic>?> getNearestEventForUser(String userId);
  Future<List<Map<String, dynamic>>> getEventsForUserAndMonth(String userId, int year, int month);
  Future<List<Map<String, dynamic>>> getEventsForUserAndYear(String userId, int year);
}
