import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

abstract class Event {
  final String userId;
  final String title;
  final String? description;
  final Priority priority;
  final Timestamp? dateTime;
  final bool? hasNotification;

  Event({
    required this.userId,
    required this.title,
    this.description,
    required this.priority,
    this.dateTime,
    this.hasNotification,
  });

  String get type;

  factory Event.fromJson(Map<String, dynamic> json) {
    throw ArgumentError(
      'Event.fromJson: Cannot create instance of Event directly. Use a specific subclass (e.g., MeetingEvent, TaskEvent).',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppFirestoreFields.email: userId,
      AppFirestoreFields.title: title,
      AppFirestoreFields.description: description,
      AppFirestoreFields.priority: priority.toFormattedString(),
      AppFirestoreFields.dateTime: dateTime,
      AppFirestoreFields.notification: hasNotification,
      AppFirestoreFields.type: type,
    };
  }

  String? get location => null;
  String? get subject => null;
  String? get withPerson => null;
  bool get withPersonYesNo => false;
}
