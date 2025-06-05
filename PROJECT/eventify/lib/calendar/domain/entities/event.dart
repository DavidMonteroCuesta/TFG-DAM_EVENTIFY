import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

// Clase abstracta que representa un evento genérico
abstract class Event {
  final String userId; // ID del usuario propietario del evento
  final String title; // Título del evento
  final String? description; // Descripción opcional
  final Priority priority; // Prioridad del evento
  final Timestamp? dateTime; // Fecha y hora del evento
  final bool? hasNotification; // Indica si tiene notificación

  Event({
    required this.userId,
    required this.title,
    this.description,
    required this.priority,
    this.dateTime,
    this.hasNotification,
  });

  // Propiedad que debe ser implementada por subclases para indicar el tipo de evento
  String get type;

  // No se puede instanciar Event directamente, solo subclases
  factory Event.fromJson(Map<String, dynamic> json) {
    throw ArgumentError(
      'Event.fromJson: Cannot create instance of Event directly. Use a specific subclass (e.g., MeetingEvent, TaskEvent).',
    );
  }

  // Serializa el evento a un Map para Firestore
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
