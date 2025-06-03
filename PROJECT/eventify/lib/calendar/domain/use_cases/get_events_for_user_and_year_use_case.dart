import 'package:eventify/calendar/domain/repositories/event_repository.dart';

/// Caso de uso para obtener los eventos de un usuario en un año específico
class GetEventsForUserAndYearUseCase {
  final EventRepository eventRepository;

  GetEventsForUserAndYearUseCase(this.eventRepository);

  Future<List<Map<String, dynamic>>> execute(String userId, int year) async {
    return await eventRepository.getEventsForUserAndYear(userId, year);
  }
}
