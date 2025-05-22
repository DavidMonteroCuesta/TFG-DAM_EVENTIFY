import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
// import 'package:eventify/di/service_locator.dart'; // Not needed here if injected correctly

class AddEventUseCase {
  final EventRepository eventRepository;

  // Constructor with required dependency injection
  AddEventUseCase({required this.eventRepository});

  // Now returns the document ID
  Future<String> execute(String userId, Event event) async {
    return await eventRepository.addEvent(userId, event);
  }
}
