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

  void _safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) {
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
    _safeNotifyListeners();
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
      _isNearestEventLoaded = false;
      await loadNearestEvent();
      _safeNotifyListeners();
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Error al guardar el evento: $error';
      _safeNotifyListeners();
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
      String? withPerson,
      bool withPersonYesNo,
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

  Future<void> getEventsForCurrentUser() async {
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
      _events = await _getEventsForUserUseCase.execute(userId);
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events: $e';
      _safeNotifyListeners();
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
      _nearestEvent = await _getNearestEventUseCase.execute(userId);
      _isNearestEventLoaded = true;
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch nearest event: $e';
      _safeNotifyListeners();
    }
  }

  Future<void> getEventsForCurrentUserAndMonth(int year, int month) async {
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
      _events = await _getEventsForUserAndMonthUseCase.execute(userId, year, month);
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events for month: $e';
      _safeNotifyListeners();
    }
  }

  Future<void> getEventsForCurrentUserAndYear(int year) async {
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
      _events = await _getEventsForUserAndYearUseCase.execute(userId, year);
      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events for year: $e';
      _safeNotifyListeners();
    }
  }
}
