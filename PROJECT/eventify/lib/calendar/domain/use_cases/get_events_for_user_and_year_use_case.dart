import 'package:eventify/calendar/domain/repositories/event_repository.dart';

class GetEventsForUserAndYearUseCase {
  final EventRepository eventRepository;

  GetEventsForUserAndYearUseCase(this.eventRepository);

  // Now returns List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> execute(String userId, int year) async {
    return await eventRepository.getEventsForUserAndYear(userId, year);
  }
}
