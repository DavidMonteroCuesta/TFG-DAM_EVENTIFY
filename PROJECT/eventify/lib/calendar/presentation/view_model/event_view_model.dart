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
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_month_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_year_use_case.dart';

class EventViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<Event> _events = [];
  List<Event> get events => _events;

  Event? _nearestEvent;
  Event? get nearestEvent => _nearestEvent;

  bool _isNearestEventLoaded = false; // Bandera para controlar la carga inicial

  final EventRepository _eventRepository;
  late final AddEventUseCase _addEventUseCase;
  late final GetEventsForUserUseCase _getEventsForUserUseCase;
  late final GetNearestEventUseCase _getNearestEventUseCase;
  late final GetEventsForUserAndMonthUseCase _getEventsForUserAndMonthUseCase;
  late final GetEventsForUserAndYearUseCase _getEventsForUserAndYearUseCase;

  EventViewModel()
      : _eventRepository = EventRepositoryImpl(
            remoteDataSource: EventRemoteDataSource()) {
    _addEventUseCase = AddEventUseCase();
    _getEventsForUserUseCase = GetEventsForUserUseCase(_eventRepository);
    _getNearestEventUseCase = GetNearestEventUseCase(_eventRepository);
    _getEventsForUserAndMonthUseCase = GetEventsForUserAndMonthUseCase(_eventRepository);
    _getEventsForUserAndYearUseCase = GetEventsForUserAndYearUseCase(_eventRepository);
  }

  // Centraliza la llamada a notifyListeners para asegurar que siempre sea post-frame
  void _safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) { // Asegura que el widget aún está montado y tiene listeners
        notifyListeners();
      }
    });
  }

  void setLoading(bool value) {
    _isLoading = value;
    _safeNotifyListeners();
  }

  Future<void> addEvent(
    EventType type,
    String title,
    String? description,
    Priority priority,
    Timestamp? dateTime,
    bool hasNotification,
    String? location,
    String? subject,
    String? withPerson,
    bool withPersonYesNo,
    BuildContext context,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners(); // Notifica el estado de carga inicial
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado. No se puede guardar el evento.';
        _safeNotifyListeners();
        return;
      }

      final eventData = {
        'id': UniqueKey().toString(),
        'title': title,
        'description': description,
        'priority': priority,
        'dateTime': dateTime,
        'hasNotification': hasNotification,
        'type': type.toString().split('.').last,
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
      _isNearestEventLoaded = false; // Resetea la bandera para forzar recarga
      await loadNearestEvent(); // Recarga el evento más cercano después de añadir
      _safeNotifyListeners(); // Notifica el estado final de éxito
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Error al guardar el evento: $error';
      _safeNotifyListeners(); // Notifica el estado final de error
    }
  }

  Future<void> updateEvent(
      String eventId,
      EventType type,
      String title,
      String? description,
      Priority priority,
      Timestamp? dateTime,
      bool hasNotification,
      String? location,
      String? subject,
      bool withPersonYesNo,
      String? withPerson,
      BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'User not authenticated';
        _safeNotifyListeners();
        return;
      }
      // Aquí deberías llamar a un use case de actualización
      // final updatedEvent = EventFactory.createEvent(type, eventData, userId, context);
      // await _updateEventUseCase.execute(userId, eventId, updatedEvent);
      _isLoading = false;
      _isNearestEventLoaded = false;
      await loadNearestEvent();
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update event: $e';
      _safeNotifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        _safeNotifyListeners();
        return;
      }
      // await _deleteEventUseCase.execute(userId, eventId);
      _isLoading = false;
      _isNearestEventLoaded = false;
      await loadNearestEvent();
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to delete event: $e';
      _safeNotifyListeners();
    }
  }

  Future<List<Event>> getEventsForCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        _isLoading = false;
        _safeNotifyListeners();
        return [];
      }
      _events = await _getEventsForUserUseCase.execute(userId);
      _isLoading = false;
      _safeNotifyListeners();
      return _events;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events: $e';
      _safeNotifyListeners();
      return [];
    }
  }

  Future<void> loadNearestEvent({bool force = false}) async {
    if (_isNearestEventLoaded && !force) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        _isLoading = false;
        _safeNotifyListeners();
        return;
      }

      // Obtener todos los eventos del usuario
      final allEvents = await _getEventsForUserUseCase.execute(userId);

      // Filtrar eventos pasados y los que no tienen fecha/hora
      final now = DateTime.now();
      final futureEvents = allEvents.where((event) {
        return event.dateTime != null && event.dateTime!.toDate().isAfter(now.subtract(const Duration(minutes: 1)));
      }).toList();

      // Ordenar eventos: primero por fecha/hora ascendente, luego por prioridad (Critical > High > Medium > Low)
      futureEvents.sort((a, b) {
        // Ordenar por fecha/hora
        final dateComparison = a.dateTime!.toDate().compareTo(b.dateTime!.toDate());
        if (dateComparison != 0) {
          return dateComparison;
        }

        // Si las fechas son iguales, ordenar por prioridad
        return _getPriorityValue(b.priority).compareTo(_getPriorityValue(a.priority));
      });

      _nearestEvent = futureEvents.isNotEmpty ? futureEvents.first : null;
      _isNearestEventLoaded = true;
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch nearest event: $e';
      _safeNotifyListeners();
    }
  }

  // Helper para obtener un valor numérico de la prioridad para la ordenación
  int _getPriorityValue(Priority priority) {
    switch (priority) {
      case Priority.critical:
        return 4;
      case Priority.high:
        return 3;
      case Priority.medium:
        return 2;
      case Priority.low:
        return 1;
      default:
        return 0;
    }
  }

  Future<List<Event>> getEventsForCurrentUserAndMonth(int year, int month) async { // Cambiado el tipo de retorno
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        _isLoading = false;
        _safeNotifyListeners();
        return []; // Retorna una lista vacía en caso de error
      }
      _events = await _getEventsForUserAndMonthUseCase.execute(userId, year, month);
      _isLoading = false;
      _safeNotifyListeners();
      return _events; // Retorna la lista de eventos
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events for month: $e';
      _safeNotifyListeners();
      return []; // Retorna una lista vacía en caso de error
    }
  }

  Future<List<Event>> getEventsForCurrentUserAndYear(int year) async { // Cambiado el tipo de retorno
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        _isLoading = false;
        _safeNotifyListeners();
        return []; // Retorna una lista vacía en caso de error
      }
      _events = await _getEventsForUserAndYearUseCase.execute(userId, year);
      _isLoading = false;
      _safeNotifyListeners();
      return _events; // Retorna la lista de eventos
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events for year: $e';
      _safeNotifyListeners();
      return []; // Retorna una lista vacía en caso de error
    }
  }
}
