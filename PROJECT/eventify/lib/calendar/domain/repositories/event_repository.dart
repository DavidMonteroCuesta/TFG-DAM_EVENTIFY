import 'package:eventify/calendar/domain/entities/event.dart';

abstract class EventRepository {
  Future<void> addEvent(String userId, Event event);
  Future<void> updateEvent(String userId, String eventId, Event event);
  Future<void> deleteEvent(String userId, String eventId);
}