import 'package:eventify/calendar/domain/entities/event.dart';

class ExamEvent extends Event {
  final String? subject;

  ExamEvent({
    required super.id,
    required super.title,
    super.description,
    required super.priority,
    super.date,
    super.time, // Usamos String
    super.hasNotification,
    required super.userId,
    this.subject,
  });
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'priority': priority.toString(),
      'date': date?.toIso8601String(),
      'time': time,
      'hasNotification': hasNotification,
      'type': 'Exam',
      'subject': subject,
    };
  }
}