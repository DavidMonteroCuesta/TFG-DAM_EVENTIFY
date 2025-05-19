import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/common/utils/priorities/priorities_enum.dart';

class ExamEvent extends Event {
  final String? subject;

  ExamEvent({
    required super.title,
    super.description,
    required super.priority,
    super.date,
    super.time,
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
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time'],
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
       'priority': priority.toString(),
    };
  }
}