import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

class ConferenceEvent extends Event {
  @override
  final String? location;

  @override
  String get type => AppFirestoreFields.typeConference;

  ConferenceEvent({
    required super.title,
    super.description,
    required super.priority,
    super.dateTime,
    super.hasNotification,
    required super.userId,
    this.location,
  }) : super();

  factory ConferenceEvent.fromJson(Map<String, dynamic> json) {
    return ConferenceEvent(
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

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      AppFirestoreFields.type: AppFirestoreFields.typeConference,
      AppFirestoreFields.location: location,
      AppFirestoreFields.priority: priority.toFormattedString(),
    };
  }
}
