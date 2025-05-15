import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';


class AddEventUseCase {
  final EventRepository eventRepository;

  AddEventUseCase({required this.eventRepository});

  Future<void> execute(String userId, Event event) async {
    await eventRepository.addEvent(userId, event);
  }
}