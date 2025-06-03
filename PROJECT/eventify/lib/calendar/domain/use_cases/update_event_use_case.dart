import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';

/// Caso de uso para actualizar un evento en el repositorio
class UpdateEventUseCase {
  final EventRepository eventRepository;

  UpdateEventUseCase({required this.eventRepository});

  Future<void> execute(String userId, String eventId, Event event) async {
    await eventRepository.updateEvent(userId, eventId, event);
  }
}
