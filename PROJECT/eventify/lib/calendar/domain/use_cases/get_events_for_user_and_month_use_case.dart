import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';

class GetEventsForUserAndMonthUseCase {
  final EventRepository _eventRepository;

  GetEventsForUserAndMonthUseCase(this._eventRepository);

  Future<List<Event>> execute(String userId, int year, int month) async {
    return await _eventRepository.getEventsForUserAndMonth(userId, year, month);
  }
}
