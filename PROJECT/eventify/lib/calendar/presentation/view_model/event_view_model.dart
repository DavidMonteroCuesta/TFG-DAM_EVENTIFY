import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/data/data_sources/event_remote_data_source.dart';
import 'package:eventify/calendar/data/repositories/event_repository_impl.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/calendar/domain/use_cases/add_event_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_nearest_event_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_month_use_case.dart'; // Importa el nuevo UseCase

class EventViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<Event> _events = []; // Lista para almacenar los eventos
  List<Event> get events => _events; // Expone la lista

  Event? _nearestEvent;
  Event? get nearestEvent => _nearestEvent;

  final EventRepository _eventRepository;
  late final AddEventUseCase _addEventUseCase;
  late final GetEventsForUserUseCase _getEventsForUserUseCase;
  late final GetNearestEventUseCase _getNearestEventUseCase;
  late final GetEventsForUserAndMonthUseCase _getEventsForUserAndMonthUseCase; // Nuevo UseCase

  EventViewModel()
      : _eventRepository = EventRepositoryImpl(
            remoteDataSource: EventRemoteDataSource()) {
    _addEventUseCase = AddEventUseCase();
    _getEventsForUserUseCase = GetEventsForUserUseCase(_eventRepository);
    _getNearestEventUseCase = GetNearestEventUseCase(_eventRepository);
    _getEventsForUserAndMonthUseCase = GetEventsForUserAndMonthUseCase(_eventRepository); // Inicializa el nuevo UseCase
  }

  // Método para actualizar el estado de carga (necesario para Calendar widget)
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addEvent(
    EventType type,
    String title,
    String? description,
    Priority priority,
    Timestamp? dateTime, // Cambiado a Timestamp
    bool hasNotification,
    String? location,
    String? subject,
    String? withPerson,
    bool withPersonYesNo,
    BuildContext context,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado. No se puede guardar el evento.';
        notifyListeners();
        return;
      }

      final eventData = {
        'id': UniqueKey().toString(),
        'title': title,
        'description': description,
        'priority': priority, // ¡Corregido! Pasa la enumeración directamente
        'dateTime': dateTime,
        'hasNotification': hasNotification,
        'type': type.toString().split('.').last, // Guarda el tipo de evento como String
        if (type == EventType.meeting ||
            type == EventType.conference ||
            type == EventType.appointment)
          'location': location,
        if (type == EventType.exam) 'subject': subject,
        if (type == EventType.appointment) 'withPerson': withPerson,
        if (type == EventType.appointment) 'withPersonYesNo': withPersonYesNo,
      };

      final Event newEvent =
          EventFactory.createEvent(type, eventData, userId, context);

      await _addEventUseCase.execute(userId, newEvent);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Error al guardar el evento: $error';
      notifyListeners();
    }
  }

  Future<void> updateEvent(
      String eventId,
      EventType type,
      String title,
      String? description,
      Priority priority,
      Timestamp? dateTime, // Cambiado a Timestamp
      bool hasNotification,
      String? location,
      String? subject,
      String? withPerson,
      bool withPersonYesNo,
      BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'User not authenticated';
        notifyListeners();
        return;
      }
      final eventData = {
        'id': eventId,
        'title': title,
        'description': description,
        'priority': priority, // ¡Corregido! Pasa la enumeración directamente
        'dateTime': dateTime,
        'hasNotification': hasNotification,
        'type': type.toString().split('.').last, // Guarda el tipo de evento como String
        if (type == EventType.meeting ||
            type == EventType.conference ||
            type == EventType.appointment)
          'location': location,
        if (type == EventType.exam) 'subject': subject,
        if (type == EventType.appointment) 'withPerson': withPerson,
        if (type == EventType.appointment) 'withPersonYesNo': withPersonYesNo,
      };
      // Aquí deberías llamar a un use case de actualización
      // EventFactory.createEvent(type, eventData, userId, context); // Esto crea un nuevo evento, no actualiza
      // await _updateEventUseCase.execute(userId, eventId, updatedEvent); // Descomentar y usar el UseCase de actualización
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update event: $e';
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        notifyListeners();
        return;
      }
      // await _deleteEventUseCase.execute(userId, eventId); // Descomentar y usar el UseCase de eliminación
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to delete event: $e';
      notifyListeners();
    }
  }

  Future<void> getEventsForCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        notifyListeners();
        return;
      }
      _events = await _getEventsForUserUseCase.execute(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events: $e';
      notifyListeners();
    }
  }

  Future<void> loadNearestEvent() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        _isLoading = false;
        notifyListeners();
        return;
      }
      _nearestEvent = await _getNearestEventUseCase.execute(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch nearest event: $e';
      notifyListeners();
    }
  }

  // Nuevo método para obtener eventos por usuario y mes
  Future<void> getEventsForCurrentUserAndMonth(int year, int month) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        _isLoading = false;
        notifyListeners();
        return;
      }
      _events = await _getEventsForUserAndMonthUseCase.execute(userId, year, month);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events for month: $e';
      notifyListeners();
    }
  }
}
