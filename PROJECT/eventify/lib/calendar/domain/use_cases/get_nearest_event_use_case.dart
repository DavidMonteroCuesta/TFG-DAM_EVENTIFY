import 'package:eventify/calendar/domain/repositories/event_repository.dart';

class GetNearestEventUseCase {
  final EventRepository _eventRepository;

  GetNearestEventUseCase(this._eventRepository);

  Future<Map<String, dynamic>?> execute(String userId) async {
    return await _eventRepository.getNearestEventForUser(userId);
  }
}