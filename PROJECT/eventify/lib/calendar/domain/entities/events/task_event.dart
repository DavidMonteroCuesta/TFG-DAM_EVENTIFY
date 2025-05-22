import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';

class TaskEvent extends Event {
  @override
  String get type => 'task';

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
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      priority: PriorityConverter.stringToPriority(json['priority']),
      dateTime: json['dateTime'],
      hasNotification: json['hasNotification'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': 'task',
      'priority': priority.toFormattedString(),
    };
  }
}