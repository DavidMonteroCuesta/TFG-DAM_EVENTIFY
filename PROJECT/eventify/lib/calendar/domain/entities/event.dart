import 'package:eventify/common/utils/priorities/priorities_enum.dart';

abstract class Event {
  final String id;
  final String title;
  final String? description;
  final Priority priority;
  final DateTime? date;
  final String? time;
  final bool hasNotification;
  final String userId;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    this.date,
    this.time, // Usamos String ahora
    this.hasNotification = false,
    required this.userId,
  });

  Map<String, dynamic> toJson();
}
