import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

// Evento de tipo examen, hereda de Event
class ExamEvent extends Event {
  @override
  String get type => AppFirestoreFields.typeExam;

  @override
  final String? subject; // Asignatura del examen

  ExamEvent({
    required super.title,
    super.description,
    required super.priority,
    super.dateTime,
    super.hasNotification,
    required super.userId,
    this.subject,
  }) : super();

  // Crea una instancia de ExamEvent a partir de un Map
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

  // Serializa el examen a un Map para Firestore
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
