import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import '../data_sources/event_remote_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addEvent(String userId, Event event) async {
    await remoteDataSource.addEvent(userId, event.toJson());
  }
    @override
  Future<void> updateEvent(String userId, String eventId, Event event) async {
       await remoteDataSource.updateEvent(userId, eventId, event.toJson());
  }

  @override
  Future<void> deleteEvent(String userId, String eventId) async {
    await remoteDataSource.deleteEvent(userId, eventId);
  }
}