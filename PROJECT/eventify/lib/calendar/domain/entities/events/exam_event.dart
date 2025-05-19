import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';

class ExamEvent extends Event {
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
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      priority: PriorityConverter.stringToPriority(json['priority']),
      dateTime: json['dateTime'],
      hasNotification: json['hasNotification'],
      subject: json['subject'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': 'exam',
      'subject': subject,
      'priority': priority.toFormattedString(),
    };
  }
}