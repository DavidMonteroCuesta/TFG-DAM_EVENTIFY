import 'package:eventify/calendar/domain/repositories/event_repository.dart';

class GetEventsForUserAndMonthUseCase {
  final EventRepository eventRepository;

  GetEventsForUserAndMonthUseCase(this.eventRepository);

  // Now returns List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> execute(String userId, int year, int month) async {
    return await eventRepository.getEventsForUserAndMonth(userId, year, month);
  }
}
