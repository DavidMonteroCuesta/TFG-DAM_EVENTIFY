import 'package:eventify/calendar/domain/entities/event.dart';

abstract class EventRepository {
  Future<void> addEvent(String userId, Event event);
  Future<void> updateEvent(String userId, String eventId, Event event);
  Future<void> deleteEvent(String userId, String eventId);
  Future<List<Event>> getEventsForUser(String userId);
  Future<Event?> getNearestEventForUser(String userId);
  Future<List<Event>> getEventsForUserAndMonth(String userId, int year, int month); // Nuevo método
}
