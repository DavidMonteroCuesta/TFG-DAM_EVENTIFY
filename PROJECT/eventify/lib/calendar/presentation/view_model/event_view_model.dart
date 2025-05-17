import 'package:eventify/calendar/data/data_sources/event_remote_data_source.dart';
import 'package:eventify/calendar/data/repositories/event_repository_impl.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:eventify/calendar/domain/entities/events_type_enum.dart';
import 'package:eventify/calendar/domain/repositories/event_repository.dart';
import 'package:eventify/common/utils/priorities/priorities_enum.dart';
import 'package:eventify/calendar/domain/use_cases/add_event_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventify/calendar/domain/use_cases/get_events_for_user_use_case.dart';

class EventViewModel extends ChangeNotifier {
  // final AddEventUseCase addEventUseCase;
  // Agrega los UseCases para actualizar y eliminar
  //final UpdateEventUseCase updateEventUseCase;
  //final DeleteEventUseCase deleteEventUseCase;
  // final GetEventsForUserUseCase getEventsForUserUseCase; // Add the new use case
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<Event> _events = []; // Add a list to hold the events
  List<Event> get events => _events; // Expose the list
  final EventRepository _eventRepository;
  late final AddEventUseCase _addEventUseCase;
  //late final UpdateEventUseCase _updateEventUseCase;
  //late final DeleteEventUseCase _deleteEventUseCase;
  late final GetEventsForUserUseCase _getEventsForUserUseCase;
  
  EventViewModel()
      : _eventRepository = EventRepositoryImpl(
            remoteDataSource: EventRemoteDataSource()) {
    _addEventUseCase = AddEventUseCase();
    //_updateEventUseCase = UpdateEventUseCase(_eventRepository);
    //_deleteEventUseCase = DeleteEventUseCase(_eventRepository);
    _getEventsForUserUseCase = GetEventsForUserUseCase(_eventRepository);
  }

  Future<void> addEvent(
    EventType type,
    String title,
    String? description,
    Priority priority,
    DateTime? date,
    String? time,
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
      // 1. Obtener el ID del usuario autenticado
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado. No se puede guardar el evento.';
        notifyListeners();
        return;
      }

      // 2. Crear el mapa de datos del evento
      final eventData = {
        'id': UniqueKey().toString(), // Generar un ID único para el evento
        'title': title,
        'description': description,
        'priority': priority,
        'date': date,
        'time': time,
        'hasNotification': hasNotification,
        // Añade los campos específicos del tipo de evento
        if (type == EventType.meeting ||
            type == EventType.conference ||
            type == EventType.appointment)
          'location': location,
        if (type == EventType.exam) 'subject': subject,
        if (type == EventType.appointment) 'withPerson': withPerson,
        if (type == EventType.appointment) 'withPersonYesNo': withPersonYesNo,
      };

      // 3. Crear el objeto Event usando la factoría
      final Event newEvent =
          EventFactory.createEvent(type, eventData, userId, context); // Pasamos el userId y context

      // 4. Llamar al caso de uso para agregar el evento
      await _addEventUseCase.execute(userId, newEvent);

      _isLoading = false;
      notifyListeners();
      print('Evento guardado exitosamente para el usuario: $userId');
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Error al guardar el evento: $error';
      notifyListeners();
      print('Error al guardar el evento: $error');
      // Aquí podrías manejar el error de una manera más específica.
    }
  }

  // Implementa los métodos para actualizar y eliminar eventos de manera similar
  Future<void> updateEvent(
      String eventId,
      EventType type,
      String title,
      String? description,
      Priority priority,
      DateTime? date,
      TimeOfDay? time,
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
        _errorMessage = 'Usuario no autenticado';
        notifyListeners();
        return;
      }
      final eventData = {
        'id': eventId,
        'title': title,
        'description': description,
        'priority': priority,
        'date': date,
        'time': time,
        'hasNotification': hasNotification,
        if (type == EventType.meeting ||
            type == EventType.conference ||
            type == EventType.appointment)
          'location': location,
        if (type == EventType.exam) 'subject': subject,
        if (type == EventType.appointment) 'withPerson': withPerson,
        if (type == EventType.appointment) 'withPersonYesNo': withPersonYesNo,
      };
      EventFactory.createEvent(type, eventData, userId, context);
      //await updateEventUseCase.execute(userId, eventId, updatedEvent); // Suponiendo que tienes un caso de uso para esto
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
      //await deleteEventUseCase.execute(userId, eventId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to delete event: $e';
      notifyListeners();
    }
  }

  // New method to get events for the current user
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
}

