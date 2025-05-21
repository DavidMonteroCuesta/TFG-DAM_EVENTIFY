import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/events/appointment_event.dart';
import 'package:eventify/calendar/domain/entities/events/conference_event.dart';
import 'package:eventify/calendar/domain/entities/events/exam_event.dart';
import 'package:eventify/calendar/domain/entities/events/meeting_event.dart';
import 'package:eventify/calendar/domain/entities/events/task_event.dart';
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

  @override
  Future<List<Event>> getEventsForUser(String userId) async {
    final List<Map<String, dynamic>> eventDataList =
        await remoteDataSource.getEventsForUser(userId);

    return eventDataList.map((eventData) {
      final String eventType = eventData['type'] ?? 'task';
      switch (eventType) {
        case 'meeting':
          return MeetingEvent.fromJson(eventData);
        case 'exam':
          return ExamEvent.fromJson(eventData);
        case 'conference':
          return ConferenceEvent.fromJson(eventData);
        case 'appointment':
          return AppointmentEvent.fromJson(eventData);
        case 'task':
        default:
          return TaskEvent.fromJson(eventData);
      }
    }).toList();
  }

  @override
  Future<Event?> getNearestEventForUser(String userId) async {
    final Map<String, dynamic>? eventData =
        await remoteDataSource.getNearestEventForUser(userId);
    if (eventData == null) {
      return null;
    }
    final String eventType = eventData['type'] ?? 'task';
    switch (eventType) {
      case 'meeting':
        return MeetingEvent.fromJson(eventData);
      case 'exam':
        return ExamEvent.fromJson(eventData);
      case 'conference':
        return ConferenceEvent.fromJson(eventData);
      case 'appointment':
        return AppointmentEvent.fromJson(eventData);
      case 'task':
      default:
        return TaskEvent.fromJson(eventData);
    }
  }

  @override
  Future<List<Event>> getEventsForUserAndMonth(String userId, int year, int month) async {
    final List<Map<String, dynamic>> eventDataList =
        await remoteDataSource.getEventsForUserAndMonth(userId, year, month);

    return eventDataList.map((eventData) {
      final String eventType = eventData['type'] ?? 'task';
      switch (eventType) {
        case 'meeting':
          return MeetingEvent.fromJson(eventData);
        case 'exam':
          return ExamEvent.fromJson(eventData);
        case 'conference':
          return ConferenceEvent.fromJson(eventData);
        case 'appointment':
          return AppointmentEvent.fromJson(eventData);
        case 'task':
        default:
          return TaskEvent.fromJson(eventData);
      }
    }).toList();
  }

  // NUEVO: Implementación para obtener eventos por año
  @override
  Future<List<Event>> getEventsForUserAndYear(String userId, int year) async {
    final List<Map<String, dynamic>> eventDataList =
        await remoteDataSource.getEventsForUserAndYear(userId, year);

    return eventDataList.map((eventData) {
      final String eventType = eventData['type'] ?? 'task';
      switch (eventType) {
        case 'meeting':
          return MeetingEvent.fromJson(eventData);
        case 'exam':
          return ExamEvent.fromJson(eventData);
        case 'conference':
          return ConferenceEvent.fromJson(eventData);
        case 'appointment':
          return AppointmentEvent.fromJson(eventData);
        case 'task':
        default:
          return TaskEvent.fromJson(eventData);
      }
    }).toList();
  }
}
