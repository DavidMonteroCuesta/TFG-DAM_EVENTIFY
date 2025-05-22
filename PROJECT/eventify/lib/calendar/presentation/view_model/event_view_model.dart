import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/data/data_sources/event_remote_data_source.dart';
import 'package:eventify/calendar/data/repositories/event_repository_impl.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/calendar/domain/use_cases/add_event_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/delete_event_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/update_event_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_month_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_year_use_case.dart';

class EventViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> get events => _events;

  Event? _nearestEvent;
  Event? get nearestEvent => _nearestEvent;

  bool _isNearestEventLoaded = false; // Flag to control initial load

  final EventRepository _eventRepository;
  late final AddEventUseCase _addEventUseCase;
  late final GetEventsForUserUseCase _getEventsForUserUseCase;
  late final GetEventsForUserAndMonthUseCase _getEventsForUserAndMonthUseCase;
  late final GetEventsForUserAndYearUseCase _getEventsForUserAndYearUseCase;
  late final UpdateEventUseCase _updateEventUseCase;
  late final DeleteEventUseCase _deleteEventUseCase;

  EventViewModel()
      : _eventRepository = EventRepositoryImpl(
            remoteDataSource: EventRemoteDataSource()) {
    _addEventUseCase = AddEventUseCase(eventRepository: _eventRepository);
    _getEventsForUserUseCase = GetEventsForUserUseCase(_eventRepository);
    _getEventsForUserAndMonthUseCase = GetEventsForUserAndMonthUseCase(_eventRepository);
    _getEventsForUserAndYearUseCase = GetEventsForUserAndYearUseCase(_eventRepository);
    _updateEventUseCase = UpdateEventUseCase(eventRepository: _eventRepository);
    _deleteEventUseCase = DeleteEventUseCase(eventRepository: _eventRepository);
  }

  void _safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) { // Ensure the widget is still mounted and has listeners
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
    // *** ELIMINADO: BuildContext context de aquí ***
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners(); // Notify initial loading state
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'User not authenticated. Cannot save event.';
        _safeNotifyListeners();
        return;
      }

      final Map<String, dynamic> eventDataPayload = {
        'title': title,
        'description': description,
        'priority': priority.toString().split('.').last, // Store as string
        'dateTime': dateTime,
        'hasNotification': hasNotification,
        'type': type.toString().split('.').last, // Store as string
        if (type == EventType.meeting ||
            type == EventType.conference ||
            type == EventType.appointment)
          'location': location,
        if (type == EventType.exam) 'subject': subject,
        if (type == EventType.appointment) 'withPerson': withPerson,
        if (type == EventType.appointment) 'withPersonYesNo': withPersonYesNo,
      };

      // Crea un objeto Event temporal para el use case (no tendrá ID aún)
      // *** ELIMINADO: context de la llamada a EventFactory.createEvent ***
      final Event newEvent = EventFactory.createEvent(type, eventDataPayload, userId);

      final String generatedId = await _addEventUseCase.execute(userId, newEvent);

      final Map<String, dynamic> eventDataWithId = {
        ...eventDataPayload,
        'id': generatedId,
        'userId': userId, // Asegura que userId también esté presente para consistencia local
      };

      _events.add(eventDataWithId);

      _isLoading = false;
      _isNearestEventLoaded = false; // Resetea la bandera para forzar recarga
      await loadNearestEvent(); // Recarga el evento más cercano después de añadir
      _safeNotifyListeners(); // Notifica el estado final de éxito
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Failed to save event: $error';
      _safeNotifyListeners(); // Notifica el estado final de error
    }
  }

  Future<void> updateEvent(
      String eventId, // Event ID is required for update
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
      // *** ELIMINADO: BuildContext context de aquí ***
      ) async {
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

      final Map<String, dynamic> eventDataPayload = {
        'title': title,
        'description': description,
        'priority': priority.toString().split('.').last, // Store as string
        'dateTime': dateTime,
        'hasNotification': hasNotification,
        'type': type.toString().split('.').last, // Store as string
        if (type == EventType.meeting ||
            type == EventType.conference ||
            type == EventType.appointment)
          'location': location,
        if (type == EventType.exam) 'subject': subject,
        if (type == EventType.appointment) 'withPerson': withPerson,
        if (type == EventType.appointment) 'withPersonYesNo': withPersonYesNo,
      };

      // Crea un objeto Event a partir de los datos actualizados (no tendrá un campo ID en sí mismo)
      // *** ELIMINADO: context de la llamada a EventFactory.createEvent ***
      final Event updatedEvent = EventFactory.createEvent(type, eventDataPayload, userId);

      await _updateEventUseCase.execute(userId, eventId, updatedEvent);

      // Actualiza la lista local
      final int index = _events.indexWhere((e) => e['id'] == eventId);
      if (index != -1) {
        _events[index] = { ...eventDataPayload, 'id': eventId, 'userId': userId }; 
      }

      _isLoading = false;
      _isNearestEventLoaded = false;
      await loadNearestEvent(); // Recarga el evento más cercano después de la actualización
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
        _errorMessage = 'User not authenticated';
        _safeNotifyListeners();
        return;
      }
      await _deleteEventUseCase.execute(userId, eventId); // Llama al use case de eliminación

      // Elimina de la lista local
      _events.removeWhere((event) => event['id'] == eventId);

      _isLoading = false;
      _isNearestEventLoaded = false;
      await loadNearestEvent(); // Recarga el evento más cercano después de la eliminación
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to delete event: $e';
      _safeNotifyListeners();
    }
  }

  Future<void> getEventsForCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'User not authenticated';
        _isLoading = false;
        _safeNotifyListeners();
        _events = []; // Limpia los eventos si no está autenticado
        return;
      }
      // Obtiene la lista de mapas (incluyendo 'id')
      _events = await _getEventsForUserUseCase.execute(userId);
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events: $e';
      _safeNotifyListeners();
      _events = []; // Limpia los eventos en caso de error
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
        _errorMessage = 'User not authenticated';
        _isLoading = false;
        _safeNotifyListeners();
        _nearestEvent = null;
        return;
      }

      // Obtiene todos los datos de eventos del usuario como List<Map<String, dynamic>>
      final List<Map<String, dynamic>> allEventsData = await _getEventsForUserUseCase.execute(userId);

      // Convierte los mapas a objetos Event para la lógica, ya que la entidad Event ya no contiene 'id'
      // *** ELIMINADO: context de la llamada a EventFactory.createEvent ***
      final List<Event> allEvents = allEventsData.map((data) => EventFactory.createEvent(
        _getEventTypeFromString(data['type'] ?? 'task'), data, userId
      )).toList();


      // Filtra eventos pasados y aquellos sin fecha/hora
      final now = DateTime.now();
      final futureEvents = allEvents.where((event) {
        return event.dateTime != null && event.dateTime!.toDate().isAfter(now.subtract(const Duration(minutes: 1)));
      }).toList();

      // Ordena eventos: primero por fecha/hora ascendente, luego por prioridad (Critical > High > Medium > Low)
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
      _nearestEvent = null;
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
    }
  }

  // Helper para convertir string type a EventType enum
  EventType _getEventTypeFromString(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'meeting':
        return EventType.meeting;
      case 'exam':
        return EventType.exam;
      case 'conference':
        return EventType.conference;
      case 'appointment':
        return EventType.appointment;
      case 'task':
      default:
        return EventType.task;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForCurrentUserAndMonth(int year, int month) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'User not authenticated';
        _isLoading = false;
        _safeNotifyListeners();
        return []; // Retorna una lista vacía en caso de error
      }
      _events = await _getEventsForUserAndMonthUseCase.execute(userId, year, month);
      _isLoading = false;
      _safeNotifyListeners();
      return _events; // Retorna la lista de mapas de eventos
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events for month: $e';
      _safeNotifyListeners();
      return []; // Retorna una lista vacía en caso de error
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForCurrentUserAndYear(int year) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'User not authenticated';
        _isLoading = false;
        _safeNotifyListeners();
        return []; // Retorna una lista vacía en caso de error
      }
      _events = await _getEventsForUserAndYearUseCase.execute(userId, year);
      _isLoading = false;
      _safeNotifyListeners();
      return _events; // Retorna la lista de mapas de eventos
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events for year: $e';
      _safeNotifyListeners();
      return []; // Retorna una lista vacía en caso de error
    }
  }
}
