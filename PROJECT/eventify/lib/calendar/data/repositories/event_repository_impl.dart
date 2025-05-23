import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import '../data_sources/event_remote_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> addEvent(String userId, Event event) async {
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

  @override
  Future<List<Map<String, dynamic>>> getEventsForUser(String userId) async {
    return await remoteDataSource.getEventsForUser(userId);
  }

  @override
  Future<Map<String, dynamic>?> getNearestEventForUser(String userId) async {
    return await remoteDataSource.getNearestEventForUser(userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getEventsForUserAndMonth(String userId, int year, int month) async {
    return await remoteDataSource.getEventsForUserAndMonth(userId, year, month);
  }

  @override
  Future<List<Map<String, dynamic>>> getEventsForUserAndYear(String userId, int year) async {
    return await remoteDataSource.getEventsForUserAndYear(userId, year);
  }
}
