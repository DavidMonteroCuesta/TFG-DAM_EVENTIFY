import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

class ExamEvent extends Event {
  @override
  String get type => AppFirestoreFields.typeExam;

  @override
  final String? subject;

  ExamEvent({
    required super.title,
    super.description,
    required super.priority,
    super.dateTime,
    super.hasNotification,
    required super.userId,
    this.subject,
  }) : super();

  factory ExamEvent.fromJson(Map<String, dynamic> json) {
    return ExamEvent(
      userId: json[AppFirestoreFields.email] ?? '',
      title: json[AppFirestoreFields.title] ?? '',
      description: json[AppFirestoreFields.description],
      priority: PriorityConverter.stringToPriority(
        json[AppFirestoreFields.priority],
      ),
      dateTime: json[AppFirestoreFields.dateTime],
      hasNotification: json[AppFirestoreFields.notification],
      subject: json[AppFirestoreFields.subject],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      AppFirestoreFields.type: AppFirestoreFields.typeExam,
      AppFirestoreFields.subject: subject,
      AppFirestoreFields.priority: priority.toFormattedString(),
    };
  }
}
