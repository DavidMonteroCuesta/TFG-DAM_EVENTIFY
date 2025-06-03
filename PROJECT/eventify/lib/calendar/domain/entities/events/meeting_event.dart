import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

/// Evento de tipo reunión, hereda de Event
class MeetingEvent extends Event {
  @override
  String get type => AppFirestoreFields.typeMeeting;

  @override
  final String? location; // Ubicación de la reunión

  MeetingEvent({
    required super.title,
    super.description,
    required super.priority,
    super.dateTime,
    super.hasNotification,
    required super.userId,
    this.location,
  }) : super();

  // Crea una instancia de MeetingEvent a partir de un Map
  factory MeetingEvent.fromJson(Map<String, dynamic> json) {
    return MeetingEvent(
      userId: json[AppFirestoreFields.email] ?? '',
      title: json[AppFirestoreFields.title] ?? '',
      description: json[AppFirestoreFields.description],
      priority: PriorityConverter.stringToPriority(
        json[AppFirestoreFields.priority],
      ),
      dateTime: json[AppFirestoreFields.dateTime],
      hasNotification: json[AppFirestoreFields.notification],
      location: json[AppFirestoreFields.location],
    );
  }

  // Serializa la reunión a un Map para Firestore
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      AppFirestoreFields.type: AppFirestoreFields.typeMeeting,
      AppFirestoreFields.location: location,
      AppFirestoreFields.priority: priority.toFormattedString(),
    };
  }
}
