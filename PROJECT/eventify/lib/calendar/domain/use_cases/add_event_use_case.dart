import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';

/// Caso de uso para añadir un nuevo evento a un usuario
class AddEventUseCase {
  final EventRepository eventRepository;

  AddEventUseCase({required this.eventRepository});

  Future<String> execute(String userId, Event event) async {
    return await eventRepository.addEvent(userId, event);
  }
}
