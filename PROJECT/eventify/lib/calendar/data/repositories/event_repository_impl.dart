import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';

import '../data_sources/event_remote_data_source.dart';

// Implementación del repositorio de eventos, conecta la capa de dominio con la fuente de datos remota
class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  // Constructor que recibe la fuente de datos remota
  EventRepositoryImpl({required this.remoteDataSource});

  // Añade un evento para un usuario
  @override
  Future<String> addEvent(String userId, Event event) async {
    return await remoteDataSource.addEvent(userId, event.toJson());
  }

  // Actualiza un evento existente para un usuario
  @override
  Future<void> updateEvent(String userId, String eventId, Event event) async {
    await remoteDataSource.updateEvent(userId, eventId, event.toJson());
  }

  // Elimina un evento de un usuario
  @override
  Future<void> deleteEvent(String userId, String eventId) async {
    await remoteDataSource.deleteEvent(userId, eventId);
  }

  // Obtiene todos los eventos de un usuario
  @override
  Future<List<Map<String, dynamic>>> getEventsForUser(String userId) async {
    return await remoteDataSource.getEventsForUser(userId);
  }

  // Obtiene el evento más próximo para un usuario
  @override
  Future<Map<String, dynamic>?> getNearestEventForUser(String userId) async {
    return await remoteDataSource.getNearestEventForUser(userId);
  }

  // Obtiene los eventos de un usuario para un mes y año específicos
  @override
  Future<List<Map<String, dynamic>>> getEventsForUserAndMonth(String userId, int year, int month) async {
    return await remoteDataSource.getEventsForUserAndMonth(userId, year, month);
  }

  // Obtiene los eventos de un usuario para un año específico
  @override
  Future<List<Map<String, dynamic>>> getEventsForUserAndYear(String userId, int year) async {
    return await remoteDataSource.getEventsForUserAndYear(userId, year);
  }
}
