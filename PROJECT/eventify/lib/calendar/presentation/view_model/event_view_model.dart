import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/data/data_sources/event_remote_data_source.dart';
import 'package:eventify/calendar/data/repositories/event_repository_impl.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/calendar/domain/use_cases/add_event_use_case.dart';
import 'package:eventify/calendar/domain/use_cases/delete_event_use_case.dart'; // Import the new use case
import 'package:eventify/calendar/domain/use_cases/update_event_use_case.dart'; // Import the new use case
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
  List<Event> _events = [];
  List<Event> get events => _events;

  Event? _nearestEvent;
  Event? get nearestEvent => _nearestEvent;

  bool _isNearestEventLoaded = false; // Flag to control initial load

  final EventRepository _eventRepository;
  late final AddEventUseCase _addEventUseCase;
  late final GetEventsForUserUseCase _getEventsForUserUseCase;
  late final GetEventsForUserAndMonthUseCase _getEventsForUserAndMonthUseCase;
  late final GetEventsForUserAndYearUseCase _getEventsForUserAndYearUseCase;
  late final UpdateEventUseCase _updateEventUseCase; // Declare Update UseCase
  late final DeleteEventUseCase _deleteEventUseCase; // Declare Delete UseCase

  EventViewModel()
      : _eventRepository = EventRepositoryImpl(
            remoteDataSource: EventRemoteDataSource()) {
    _addEventUseCase = AddEventUseCase();
    _getEventsForUserUseCase = GetEventsForUserUseCase(_eventRepository);
    _getEventsForUserAndMonthUseCase = GetEventsForUserAndMonthUseCase(_eventRepository);
    _getEventsForUserAndYearUseCase = GetEventsForUserAndYearUseCase(_eventRepository);
    _updateEventUseCase = UpdateEventUseCase(eventRepository: _eventRepository); // Initialize Update UseCase
    _deleteEventUseCase = DeleteEventUseCase(eventRepository: _eventRepository); // Initialize Delete UseCase
  }

  // Centralize the call to notifyListeners to ensure it's always post-frame
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
    BuildContext context,
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

      final eventData = {
        'id': UniqueKey().toString(), // Generate a unique ID for new events
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

      final Event newEvent =
          EventFactory.createEvent(type, eventData, userId, context);

      await _addEventUseCase.execute(userId, newEvent);

      _isLoading = false;
      _isNearestEventLoaded = false; // Reset flag to force reload
      await loadNearestEvent(); // Reload the nearest event after adding
      _safeNotifyListeners(); // Notify final success state
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Failed to save event: $error';
      _safeNotifyListeners(); // Notify final error state
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

      final eventData = {
        'id': eventId, // Use the existing event ID for update
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

      // Create an Event object from the updated data
      final Event updatedEvent =
          EventFactory.createEvent(type, eventData, userId, context);

      await _updateEventUseCase.execute(userId, eventId, updatedEvent);

      _isLoading = false;
      _isNearestEventLoaded = false;
      await loadNearestEvent(); // Reload nearest event after update
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
      await _deleteEventUseCase.execute(userId, eventId); // Call the delete use case
      _isLoading = false;
      _isNearestEventLoaded = false;
      await loadNearestEvent(); // Reload nearest event after deletion
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
        _errorMessage = 'User not authenticated';
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
        _errorMessage = 'User not authenticated';
        _isLoading = false;
        _safeNotifyListeners();
        return;
      }

      // Get all user events
      final allEvents = await _getEventsForUserUseCase.execute(userId);

      // Filter out past events and those without date/time
      final now = DateTime.now();
      final futureEvents = allEvents.where((event) {
        return event.dateTime != null && event.dateTime!.toDate().isAfter(now.subtract(const Duration(minutes: 1)));
      }).toList();

      // Sort events: first by ascending date/time, then by priority (Critical > High > Medium > Low)
      futureEvents.sort((a, b) {
        // Sort by date/time
        final dateComparison = a.dateTime!.toDate().compareTo(b.dateTime!.toDate());
        if (dateComparison != 0) {
          return dateComparison;
        }

        // If dates are equal, sort by priority
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

  // Helper to get a numeric value for priority for sorting
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

  Future<List<Event>> getEventsForCurrentUserAndMonth(int year, int month) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'User not authenticated';
        _isLoading = false;
        _safeNotifyListeners();
        return []; // Return an empty list in case of error
      }
      _events = await _getEventsForUserAndMonthUseCase.execute(userId, year, month);
      _isLoading = false;
      _safeNotifyListeners();
      return _events; // Return the list of events
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events for month: $e';
      _safeNotifyListeners();
      return []; // Return an empty list in case of error
    }
  }

  Future<List<Event>> getEventsForCurrentUserAndYear(int year) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'User not authenticated';
        _isLoading = false;
        _safeNotifyListeners();
        return []; // Return an empty list in case of error
      }
      _events = await _getEventsForUserAndYearUseCase.execute(userId, year);
      _isLoading = false;
      _safeNotifyListeners();
      return _events; // Return the list of events
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch events for year: $e';
      _safeNotifyListeners();
      return []; // Return an empty list in case of error
    }
  }
}