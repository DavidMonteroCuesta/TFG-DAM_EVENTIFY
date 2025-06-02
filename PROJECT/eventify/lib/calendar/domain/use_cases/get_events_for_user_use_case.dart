import 'package:eventify/calendar/domain/repositories/event_repository.dart';

class GetEventsForUserUseCase {
  final EventRepository eventRepository;

  GetEventsForUserUseCase(this.eventRepository);

  Future<List<Map<String, dynamic>>> execute(String userId) async {
    return await eventRepository.getEventsForUser(userId);
  }
}
