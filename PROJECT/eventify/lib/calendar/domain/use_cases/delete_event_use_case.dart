import 'package:eventify/calendar/domain/repositories/event_repository.dart';

/// Caso de uso para eliminar un evento de un usuario
class DeleteEventUseCase {
  final EventRepository eventRepository;

  DeleteEventUseCase({required this.eventRepository});

  Future<void> execute(String userId, String eventId) async {
    await eventRepository.deleteEvent(userId, eventId);
  }
}
