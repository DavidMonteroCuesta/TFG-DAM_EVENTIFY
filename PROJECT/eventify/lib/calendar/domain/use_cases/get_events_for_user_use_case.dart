import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';

class GetEventsForUserUseCase {
  final EventRepository _eventRepository;

  GetEventsForUserUseCase(this._eventRepository);

  Future<List<Event>> execute(String userId) {
    return _eventRepository.getEventsForUser(userId);
  }
}