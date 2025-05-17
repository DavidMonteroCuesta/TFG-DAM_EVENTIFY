import 'package:eventify/calendar/data/data_sources/event_remote_data_source.dart';
import 'package:eventify/calendar/data/repositories/event_repository_impl.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';

class AddEventUseCase {
  final EventRepository eventRepository;

  AddEventUseCase({EventRepository? eventRepository}) : eventRepository =eventRepository ?? EventRepositoryImpl(remoteDataSource: EventRemoteDataSource());

  Future<void> execute(String userId, Event event) async {
    await eventRepository.addEvent(userId, event);
  }
}
