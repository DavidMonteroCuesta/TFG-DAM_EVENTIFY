import 'package:eventify/calendar/domain/repositories/event_repository.dart';

/// Caso de uso para obtener los eventos de un usuario en un mes y año específicos
class GetEventsForUserAndMonthUseCase {
  final EventRepository eventRepository;

  GetEventsForUserAndMonthUseCase(this.eventRepository);

  Future<List<Map<String, dynamic>>> execute(String userId, int year, int month) async {
    return await eventRepository.getEventsForUserAndMonth(userId, year, month);
  }
}
