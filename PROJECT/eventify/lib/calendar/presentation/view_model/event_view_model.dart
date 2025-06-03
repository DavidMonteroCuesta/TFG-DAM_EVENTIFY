import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/data/data_sources/event_remote_data_source.dart';
import 'package:eventify/calendar/data/repositories/event_repository_impl.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import 'package:eventify/calendar/domain/use_cases/add_event_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/delete_event_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_month_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_and_year_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/update_event_use_case.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventViewModel extends ChangeNotifier {
  static const int priorityCritical = 4;
  static const int priorityHigh = 3;
  static const int priorityMedium = 2;
  static const int priorityLow = 1;
  static const int nearestEventMinutesOffset = 1;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> get events => _events;

  Event? _nearestEvent;
  Event? get nearestEvent => _nearestEvent;

  bool _isNearestEventLoaded = false;

  final EventRepository _eventRepository;
  late final AddEventUseCase _addEventUseCase;
  late final GetEventsForUserUseCase _getEventsForUserUseCase;
  late final GetEventsForUserAndMonthUseCase _getEventsForUserAndMonthUseCase;
  late final GetEventsForUserAndYearUseCase _getEventsForUserAndYearUseCase;
  late final UpdateEventUseCase _updateEventUseCase;
  late final DeleteEventUseCase _deleteEventUseCase;

  EventViewModel()
    : _eventRepository = EventRepositoryImpl(
        remoteDataSource: EventRemoteDataSource(),
      ) {
    _addEventUseCase = AddEventUseCase(eventRepository: _eventRepository);
    _getEventsForUserUseCase = GetEventsForUserUseCase(_eventRepository);
    _getEventsForUserAndMonthUseCase = GetEventsForUserAndMonthUseCase(
      _eventRepository,
    );
    _getEventsForUserAndYearUseCase = GetEventsForUserAndYearUseCase(
      _eventRepository,
    );
    _updateEventUseCase = UpdateEventUseCase(eventRepository: _eventRepository);
    _deleteEventUseCase = DeleteEventUseCase(eventRepository: _eventRepository);
  }

  void _safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) {
        notifyListeners();
      }
    });
  }

  // Cambia el estado de carga y notifica
  void setLoading(bool value) {
    _isLoading = value;
    _safeNotifyListeners();
  }

  // Añade un nuevo evento al usuario actual
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
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = AppInternalConstants.eventUserNotAuthenticatedSave;
        _safeNotifyListeners();
        return;
      }

      final Map<String, dynamic> eventDataPayload = {
        AppFirestoreFields.title: title,
        AppFirestoreFields.description: description,
        AppFirestoreFields.priority: priority.toString().split('.').last,
        AppFirestoreFields.dateTime: dateTime,
        AppFirestoreFields.notification: hasNotification,
        AppFirestoreFields.type: type.toString().split('.').last,
        if (type == EventType.meeting ||
            type == EventType.conference ||
            type == EventType.appointment)
          AppFirestoreFields.location: location,
        if (type == EventType.exam) AppFirestoreFields.subject: subject,
        if (type == EventType.appointment)
          AppFirestoreFields.withPerson: withPerson,
        if (type == EventType.appointment)
          AppFirestoreFields.withPersonYesNo: withPersonYesNo,
      };

      final Event newEvent = EventFactory.createEvent(
        type,
        eventDataPayload,
        userId,
      );

      final String generatedId = await _addEventUseCase.execute(
        userId,
        newEvent,
      );

      final Map<String, dynamic> eventDataWithId = {
        ...eventDataPayload,
        AppFirestoreFields.id: generatedId,
        AppFirestoreFields.userId: userId,
      };

      _events.add(eventDataWithId);

      _isLoading = false;
      _isNearestEventLoaded = false;
      await loadNearestEvent();
      _safeNotifyListeners();
    } catch (error) {
      _isLoading = false;
      _errorMessage = '${AppInternalConstants.eventFailedToSave}$error';
      _safeNotifyListeners();
    }
  }

  // Actualiza un evento existente
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
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = AppInternalConstants.eventUserNotAuthenticated;
        _safeNotifyListeners();
        return;
      }

      final Map<String, dynamic> eventDataPayload = {
        AppFirestoreFields.title: title,
        AppFirestoreFields.description: description,
        AppFirestoreFields.priority: priority.toString().split('.').last,
        AppFirestoreFields.dateTime: dateTime,
        AppFirestoreFields.notification: hasNotification,
        AppFirestoreFields.type: type.toString().split('.').last,
        if (type == EventType.meeting ||
            type == EventType.conference ||
            type == EventType.appointment)
          AppFirestoreFields.location: location,
        if (type == EventType.exam) AppFirestoreFields.subject: subject,
        if (type == EventType.appointment)
          AppFirestoreFields.withPerson: withPerson,
        if (type == EventType.appointment)
          AppFirestoreFields.withPersonYesNo: withPersonYesNo,
      };

      final Event updatedEvent = EventFactory.createEvent(
        type,
        eventDataPayload,
        userId,
      );

      await _updateEventUseCase.execute(userId, eventId, updatedEvent);

      final int index = _events.indexWhere(
        (e) => e[AppFirestoreFields.id] == eventId,
      );
      if (index != -1) {
        _events[index] = {
          ...eventDataPayload,
          AppFirestoreFields.id: eventId,
          AppFirestoreFields.users: userId,
        };
      }

      _isLoading = false;
      _isNearestEventLoaded = false;
      await loadNearestEvent();
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = '${AppInternalConstants.eventFailedToUpdate}$e';
      _safeNotifyListeners();
    }
  }

  // Elimina un evento por su id
  Future<void> deleteEvent(String eventId) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = AppInternalConstants.eventUserNotAuthenticated;
        _safeNotifyListeners();
        return;
      }
      await _deleteEventUseCase.execute(userId, eventId);

      _events.removeWhere((event) => event[AppFirestoreFields.id] == eventId);

      _isLoading = false;
      _isNearestEventLoaded = false;
      await loadNearestEvent();
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = '${AppInternalConstants.eventFailedToDelete}$e';
      _safeNotifyListeners();
    }
  }

  // Obtiene todos los eventos del usuario actual
  Future<void> getEventsForCurrentUser() async {
    _initializeLoadingState();
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        _handleUserNotAuthenticated();
        return;
      }
      _events = await _getEventsForUserUseCase.execute(userId);
      _finalizeLoadingState();
    } catch (e) {
      _handleFetchError(e);
    }
  }

  // Carga el evento más próximo del usuario actual
  Future<void> loadNearestEvent({bool force = false}) async {
    if (_isNearestEventLoaded && !force) {
      return;
    }

    _initializeLoadingState();
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        _handleUserNotAuthenticated();
        _nearestEvent = null;
        return;
      }

      final List<Map<String, dynamic>> allEventsData =
          await _getEventsForUserUseCase.execute(userId);

      _nearestEvent = _findNearestEvent(allEventsData, userId);
      _isNearestEventLoaded = true;
      _finalizeLoadingState();
    } catch (e) {
      _handleFetchError(e);
      _nearestEvent = null;
    }
  }

  // Inicializa el estado de carga
  void _initializeLoadingState() {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
  }

  // Finaliza el estado de carga
  void _finalizeLoadingState() {
    _isLoading = false;
    _safeNotifyListeners();
  }

  // Obtiene el id del usuario actual
  String? _getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // Maneja el caso de usuario no autenticado
  void _handleUserNotAuthenticated() {
    _errorMessage = AppInternalConstants.eventUserNotAuthenticated;
    _isLoading = false;
    _safeNotifyListeners();
  }

  // Maneja errores al obtener eventos
  void _handleFetchError(dynamic error) {
    _isLoading = false;
    _errorMessage = '${AppInternalConstants.eventFailedToFetch}$error';
    _safeNotifyListeners();
    _events = [];
  }

  // Busca el evento más próximo a la fecha actual
  Event? _findNearestEvent(
    List<Map<String, dynamic>> allEventsData,
    String userId,
  ) {
    final List<Event> allEvents =
        allEventsData.map((data) {
          return EventFactory.createEvent(
            _getEventTypeFromString(
              data[AppFirestoreFields.type] ??
                  AppInternalConstants.eventTypeTask,
            ),
            data,
            userId,
          );
        }).toList();

    final now = DateTime.now();
    final futureEvents =
        allEvents.where((event) {
          return event.dateTime != null &&
              event.dateTime!.toDate().isAfter(
                now.subtract(
                  const Duration(minutes: nearestEventMinutesOffset),
                ),
              );
        }).toList();

    futureEvents.sort((a, b) {
      final dateComparison = a.dateTime!.toDate().compareTo(
        b.dateTime!.toDate(),
      );
      if (dateComparison != 0) {
        return dateComparison;
      }

      return _getPriorityValue(
        b.priority,
      ).compareTo(_getPriorityValue(a.priority));
    });

    return futureEvents.isNotEmpty ? futureEvents.first : null;
  }

  // Devuelve el valor numérico de la prioridad
  int _getPriorityValue(Priority priority) {
    switch (priority) {
      case Priority.critical:
        return priorityCritical;
      case Priority.high:
        return priorityHigh;
      case Priority.medium:
        return priorityMedium;
      case Priority.low:
        return priorityLow;
    }
  }

  // Convierte el string del tipo de evento a su enum correspondiente
  EventType _getEventTypeFromString(String typeString) {
    switch (typeString.toLowerCase()) {
      case AppInternalConstants.eventTypeMeeting:
        return EventType.meeting;
      case AppInternalConstants.eventTypeExam:
        return EventType.exam;
      case AppInternalConstants.eventTypeConference:
        return EventType.conference;
      case AppInternalConstants.eventTypeAppointment:
        return EventType.appointment;
      case AppInternalConstants.eventTypeTask:
      default:
        return EventType.task;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForCurrentUserAndMonth(
    int year,
    int month,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = AppInternalConstants.eventUserNotAuthenticated;
        _isLoading = false;
        _safeNotifyListeners();
        return [];
      }
      _events = await _getEventsForUserAndMonthUseCase.execute(
        userId,
        year,
        month,
      );
      _isLoading = false;
      _safeNotifyListeners();
      return _events;
    } catch (e) {
      _isLoading = false;
      _errorMessage = '${AppInternalConstants.eventFailedToFetchForMonth}$e';
      _safeNotifyListeners();
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForCurrentUserAndYear(
    int year,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = AppInternalConstants.eventUserNotAuthenticated;
        _isLoading = false;
        _safeNotifyListeners();
        return [];
      }
      _events = await _getEventsForUserAndYearUseCase.execute(userId, year);
      _isLoading = false;
      _safeNotifyListeners();
      return _events;
    } catch (e) {
      _isLoading = false;
      _errorMessage = '${AppInternalConstants.eventFailedToFetchForYear}$e';
      _safeNotifyListeners();
      return [];
    }
  }
}
