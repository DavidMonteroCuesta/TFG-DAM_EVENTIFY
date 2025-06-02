import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

class TaskEvent extends Event {
  @override
  String get type => AppFirestoreFields.typeTask;

  TaskEvent({
    required super.title,
    super.description,
    required super.priority,
    super.dateTime,
    super.hasNotification,
    required super.userId,
  }) : super();

  factory TaskEvent.fromJson(Map<String, dynamic> json) {
    return TaskEvent(
      userId: json[AppFirestoreFields.email] ?? '',
      title: json[AppFirestoreFields.title] ?? '',
      description: json[AppFirestoreFields.description],
      priority: PriorityConverter.stringToPriority(
        json[AppFirestoreFields.priority],
      ),
      dateTime: json[AppFirestoreFields.dateTime],
      hasNotification: json[AppFirestoreFields.notification],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      AppFirestoreFields.type: AppFirestoreFields.typeTask,
      AppFirestoreFields.priority: priority.toFormattedString(),
    };
  }
}
