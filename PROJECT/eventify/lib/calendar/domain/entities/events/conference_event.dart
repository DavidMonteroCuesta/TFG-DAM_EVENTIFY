import 'package:eventify/calendar/domain/entities/events/meeting_event.dart';

class ConferenceEvent extends MeetingEvent {
  ConferenceEvent({
    required super.id,
    required super.title,
    super.description,
    required super.priority,
    super.date,
    super.time,
    super.hasNotification,
    required super.userId,
    super.location,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': 'Conference',
    };
  }
}