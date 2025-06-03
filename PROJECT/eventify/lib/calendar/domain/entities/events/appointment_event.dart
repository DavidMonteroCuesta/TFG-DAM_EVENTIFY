import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';

// Evento de tipo cita, hereda de Event
class AppointmentEvent extends Event {
  @override
  String get type => AppFirestoreFields.typeAppointment;

  @override
  final bool withPersonYesNo; // Indica si la cita es con alguien
  @override
  final String? withPerson; // Persona con la que es la cita
  @override
  final String? location; // Ubicación de la cita

  AppointmentEvent({
    required super.title,
    super.description,
    required super.priority,
    super.dateTime,
    super.hasNotification,
    required super.userId,
    this.withPerson,
    required this.withPersonYesNo,
    this.location,
  }) : super();

  // Crea una instancia de AppointmentEvent a partir de un Map (por ejemplo, de Firestore)
  factory AppointmentEvent.fromJson(Map<String, dynamic> json) {
    return AppointmentEvent(
      userId: json[AppFirestoreFields.email] ?? '',
      title: json[AppFirestoreFields.title] ?? '',
      description: json[AppFirestoreFields.description],
      priority: PriorityConverter.stringToPriority(
        json[AppFirestoreFields.priority],
      ),
      dateTime: json[AppFirestoreFields.dateTime],
      hasNotification: json[AppFirestoreFields.notification],
      withPerson: json[AppFirestoreFields.withPerson],
      withPersonYesNo: json[AppFirestoreFields.withPersonYesNo] ?? false,
      location: json[AppFirestoreFields.location],
    );
  }

  // Serializa la cita a un Map para Firestore
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      AppFirestoreFields.type: AppFirestoreFields.typeAppointment,
      AppFirestoreFields.withPerson: withPerson,
      AppFirestoreFields.withPersonYesNo: withPersonYesNo,
      AppFirestoreFields.location: location,
      AppFirestoreFields.priority: priority.toFormattedString(),
    };
  }
}
