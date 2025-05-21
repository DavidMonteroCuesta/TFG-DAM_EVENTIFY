import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';

class GetEventsForUserAndYearUseCase {
  final EventRepository _eventRepository;

  GetEventsForUserAndYearUseCase(this._eventRepository);

  Future<List<Event>> execute(String userId, int year) async {
    return await _eventRepository.getEventsForUserAndYear(userId, year);
  }
}
