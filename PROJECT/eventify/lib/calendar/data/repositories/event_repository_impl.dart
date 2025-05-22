import 'package:eventify/calendar/domain/entities/event.dart';
// Event subclass imports are no longer necessary here if getEventsForUser
// returns Map<String, dynamic> directly.
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import '../data_sources/event_remote_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  // addEvent now returns the document ID
  @override
  Future<String> addEvent(String userId, Event event) async {
    // event.toJson() should not include 'id' if the Event entity doesn't have it.
    // The remoteDataSource will generate and return the ID.
    return await remoteDataSource.addEvent(userId, event.toJson());
  }

  @override
  Future<void> updateEvent(String userId, String eventId, Event event) async {
    await remoteDataSource.updateEvent(userId, eventId, event.toJson());
  }

  @override
  Future<void> deleteEvent(String userId, String eventId) async {
    await remoteDataSource.deleteEvent(userId, eventId);
  }

  // Get methods now return List<Map<String, dynamic>> directly
  @override
  Future<List<Map<String, dynamic>>> getEventsForUser(String userId) async {
    // Directly return the list of maps from the remote data source, which already includes 'id'.
    return await remoteDataSource.getEventsForUser(userId);
  }

  // getNearestEventForUser now returns Map<String, dynamic>? directly
  @override
  Future<Map<String, dynamic>?> getNearestEventForUser(String userId) async {
    // Directly return the map from the remote data source, which already includes 'id'.
    return await remoteDataSource.getNearestEventForUser(userId);
  }

  // getEventsForUserAndMonth now returns List<Map<String, dynamic>> directly
  @override
  Future<List<Map<String, dynamic>>> getEventsForUserAndMonth(String userId, int year, int month) async {
    // Directly return the list of maps from the remote data source, which already includes 'id'.
    return await remoteDataSource.getEventsForUserAndMonth(userId, year, month);
  }

  // getEventsForUserAndYear now returns List<Map<String, dynamic>> directly
  @override
  Future<List<Map<String, dynamic>>> getEventsForUserAndYear(String userId, int year) async {
    // Directly return the list of maps from the remote data source, which already includes 'id'.
    return await remoteDataSource.getEventsForUserAndYear(userId, year);
  }
}
