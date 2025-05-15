import 'package:eventify/calendar/domain/repositories/event_repository.dart';

class DeleteEventUseCase {
  final EventRepository eventRepository;
  DeleteEventUseCase({required this.eventRepository});

  Future<void> execute(String userId, String eventId) async {
    await eventRepository.deleteEvent(userId, eventId);
  }
}