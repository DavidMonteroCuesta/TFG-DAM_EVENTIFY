import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/entities/events/appointment_event.dart';
import 'package:eventify/calendar/domain/entities/events/conference_event.dart';
import 'package:eventify/calendar/domain/entities/events/exam_event.dart';
import 'package:eventify/calendar/domain/entities/events/meeting_event.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';

class EventSearchScreen extends StatefulWidget {
  const EventSearchScreen({super.key});

  @override
  State<EventSearchScreen> createState() => _EventSearchScreenState();
}

class _EventSearchScreenState extends State<EventSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleSearchController = TextEditingController();
  final _descriptionSearchController = TextEditingController();
  DateTime? _selectedSearchDate;
  EventType _selectedEventType = EventType.all;
  final _locationSearchController = TextEditingController();
  final _subjectSearchController = TextEditingController();
  final _withPersonSearchController = TextEditingController();
  bool _withPersonYesNoSearch = false;
  Priority? _selectedPriority;
  // *** CAMBIO CLAVE AQUÍ: Cambiado a List<Map<String, dynamic>> ***
  List<Map<String, dynamic>> _searchResults = [];
  late EventViewModel _eventViewModel;
  bool _enablePriorityFilter = false;

  @override
  void initState() {
    super.initState();
    _eventViewModel = sl<EventViewModel>();
    _loadEvents();
    _titleSearchController.addListener(_searchEvents);
    _descriptionSearchController.addListener(_searchEvents);
    _locationSearchController.addListener(_searchEvents); // Added listener
    _subjectSearchController.addListener(_searchEvents); // Added listener
    _withPersonSearchController.addListener(_searchEvents); // Added listener
    _searchEvents(); // Llamada inicial para mostrar todos los eventos
  }

  // Helper to convert string type to EventType enum
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
        return EventType.task;
      default:
        return EventType.all; // Default to all if type is unknown or not specified
    }
  }

  Future<void> _loadEvents() async {
    try {
      await _eventViewModel.getEventsForCurrentUser();
      // *** CAMBIO CLAVE AQUÍ: Asigna directamente la lista de mapas ***
      setState(() => _searchResults = _eventViewModel.events);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load events: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _selectSearchDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedSearchDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100), // Adjusted to 2100 for wider range
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: AppColors.primaryContainer,
            hintColor: AppColors.secondary,
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryContainer,
            ).copyWith(secondary: AppColors.secondary),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedSearchDate) {
      setState(() {
        _selectedSearchDate = picked;
        _searchEvents(); // Re-search upon date selection
      });
    }
  }

  void _clearSearchDate() {
    setState(() {
      _selectedSearchDate = null;
      _searchEvents(); // Re-search upon clearing date
    });
  }

  void _searchEvents() {
    setState(() {
      // *** CAMBIO CLAVE AQUÍ: Trabaja con List<Map<String, dynamic>> ***
      List<Map<String, dynamic>> allEventsData = _eventViewModel.events;
      List<Map<String, dynamic>> results = allEventsData;

      final title = _titleSearchController.text.toLowerCase();
      final description = _descriptionSearchController.text.toLowerCase();
      final location = _locationSearchController.text.toLowerCase();
      final subject = _subjectSearchController.text.toLowerCase();
      final withPerson = _withPersonSearchController.text.toLowerCase();

      if (title.isNotEmpty) {
        results = results
            .where((eventData) =>
                (eventData['title'] as String?)?.toLowerCase().contains(title) ?? false)
            .toList();
      }
      if (description.isNotEmpty) {
        results = results
            .where((eventData) =>
                (eventData['description'] as String?)?.toLowerCase().contains(description) ?? false)
            .toList();
      }
      if (_selectedSearchDate != null) {
        results = results.where((eventData) {
          final Timestamp? eventTimestamp = eventData['dateTime'];
          if (eventTimestamp != null) {
            // Compare only the date (year, month, day), ignoring time
            return eventTimestamp.toDate().year == _selectedSearchDate!.year &&
                   eventTimestamp.toDate().month == _selectedSearchDate!.month &&
                   eventTimestamp.toDate().day == _selectedSearchDate!.day;
          }
          return false;
        }).toList();
      }
      if (_selectedEventType != EventType.all) {
        results = results.where((eventData) {
          final eventTypeString = eventData['type'] as String?;
          if (eventTypeString == null) return false;

          final EventType eventType = _getEventTypeFromString(eventTypeString);
          return eventType == _selectedEventType;
        }).toList();
      }
      if (_enablePriorityFilter && _selectedPriority != null) {
        results = results.where((eventData) {
          final priorityString = eventData['priority'] as String?;
          if (priorityString == null) return false;
          return PriorityConverter.stringToPriority(priorityString) == _selectedPriority;
        }).toList();
      }

      // Filter by specific event type fields
      // Show location filter if type is Meeting, Conference, Appointment, or ALL
      if ((_selectedEventType == EventType.meeting ||
              _selectedEventType == EventType.conference ||
              _selectedEventType == EventType.appointment ||
              _selectedEventType == EventType.all) &&
          location.isNotEmpty) {
        results = results.where((eventData) {
          final eventTypeString = eventData['type'] as String?;
          if (eventTypeString == 'meeting' || eventTypeString == 'conference' || eventTypeString == 'appointment') {
            return (eventData['location'] as String?)?.toLowerCase().contains(location) ?? false;
          }
          return false;
        }).toList();
      }
      // Show subject filter if type is Exam or ALL
      if ((_selectedEventType == EventType.exam || _selectedEventType == EventType.all) &&
          subject.isNotEmpty) {
        results = results.where((eventData) {
          final eventTypeString = eventData['type'] as String?;
          if (eventTypeString == 'exam') {
            return (eventData['subject'] as String?)?.toLowerCase().contains(subject) ?? false;
          }
          return false;
        }).toList();
      }
      // Show withPerson filter if type is Appointment or ALL
      if ((_selectedEventType == EventType.appointment || _selectedEventType == EventType.all) &&
          _withPersonYesNoSearch) {
        results = results.where((eventData) {
          final eventTypeString = eventData['type'] as String?;
          if (eventTypeString == 'appointment') {
            final bool withPersonYesNo = eventData['withPersonYesNo'] ?? false;
            final String? eventWithPerson = eventData['withPerson'];
            return withPersonYesNo && (eventWithPerson?.toLowerCase().contains(withPerson) ?? false);
          }
          return false;
        }).toList();
      }

      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _titleSearchController.dispose();
    _descriptionSearchController.dispose();
    _locationSearchController.dispose();
    _subjectSearchController.dispose();
    _withPersonSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color headerColor = Colors.grey[800]!;
    const outlineColor = Color(0xFFE0E0E0);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: ShiningTextAnimation(
          text: "SEARCH EVENTS",
          style: TextStyles.urbanistBody1,
          shineColor: const Color(0xFFCBCBCB),
        ),
        backgroundColor: headerColor,
        foregroundColor: outlineColor,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: kToolbarHeight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchField(
                controller: _titleSearchController,
                labelText: 'Event Title',
              ),
              _buildSearchField(
                controller: _descriptionSearchController,
                labelText: 'Description',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () => _selectSearchDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date (YYYY-MM-DD)',
                      labelStyle: TextStyles.plusJakartaSansSubtitle2,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(105, 240, 174, 1),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1F1F1F),
                      suffixIcon:
                          _selectedSearchDate != null
                              ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: _clearSearchDate,
                              )
                              : const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                    ),
                    child: Text(
                      _selectedSearchDate != null
                          ? DateFormat(
                            'yyyy-MM-dd',
                          ).format(_selectedSearchDate!)
                          : 'Select Date',
                      style:
                          _selectedSearchDate != null
                              ? TextStyles.plusJakartaSansBody1
                              : TextStyles.plusJakartaSansSubtitle2,
                    ),
                  ),
                ),
              ),
              _buildDropdownField(
                value: _selectedEventType,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedEventType = newValue as EventType;
                      _searchEvents();
                    });
                  }
                },
                items:
                    EventType.values.map<DropdownMenuItem<EventType>>((
                      EventType value,
                    ) {
                      return DropdownMenuItem<EventType>(
                        value: value,
                        child: Text(
                          value == EventType.all
                              ? "ALL"
                              : value.toString().split('.').last.toUpperCase(),
                          style: TextStyles.plusJakartaSansBody2,
                        ),
                      );
                    }).toList(),
                labelText: 'Event Type',
              ),
              _buildPrioritySelector(),
              // Muestra el campo de ubicación si el tipo de evento es Meeting, Conference, Appointment o ALL
              if (_selectedEventType == EventType.meeting ||
                  _selectedEventType == EventType.conference ||
                  _selectedEventType == EventType.appointment ||
                  _selectedEventType == EventType.all)
                _buildSearchField(
                  controller: _locationSearchController,
                  labelText: 'Location',
                ),
              // Muestra el campo de asignatura si el tipo de evento es Exam o ALL
              if (_selectedEventType == EventType.exam || _selectedEventType == EventType.all)
                _buildSearchField(
                  controller: _subjectSearchController,
                  labelText: 'Subject',
                ),
              // Muestra el campo "With Person" si el tipo de evento es Appointment o ALL
              if (_selectedEventType == EventType.appointment || _selectedEventType == EventType.all)
                _buildWithPersonField(),

              if (_searchResults.isNotEmpty) ...[
                const SizedBox(height: 10.0),
                Text(
                  'Search Results (${_searchResults.length})',
                  style: TextStyles.urbanistSubtitle1.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _searchResults.map((eventData) {
                        // *** CAMBIO CLAVE AQUÍ: Crea el objeto Event para la visualización ***
                        final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
                        if (currentUserId == null) {
                          return const SizedBox.shrink();
                        }
                        final Event event = EventFactory.createEvent(
                          _getEventTypeFromString(eventData['type'] ?? 'task'),
                          eventData,
                          currentUserId,
                        );

                        String eventTypeString = 'N/A';
                        if (event is MeetingEvent) {
                          eventTypeString = 'Meeting';
                        } else if (event is ExamEvent) {
                          eventTypeString = 'Exam';
                        } else if (event is ConferenceEvent) {
                          eventTypeString = 'Conference';
                        } else if (event is AppointmentEvent) {
                          eventTypeString = 'Appointment';
                        } else {
                          eventTypeString = 'Task';
                        }
                        String formattedDateTime =
                            event.dateTime != null
                                ? DateFormat(
                                  'yyyy/MM/dd HH:mm',
                                ).format(event.dateTime!.toDate())
                                : 'N/A';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: screenWidth * 0.9,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F1F1F),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: outlineColor.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    style: TextStyles.plusJakartaSansBody1
                                        .copyWith(fontSize: 18),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Date and Time: $formattedDateTime',
                                    style: TextStyles.plusJakartaSansBody2,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Type: $eventTypeString',
                                    style: TextStyles.plusJakartaSansBody2,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Description: ${event.description ?? 'N/A'}',
                                    style: TextStyles.plusJakartaSansBody2,
                                  ),
                                  Text(
                                    'Priority: ${event.priority.toString().split('.').last.toUpperCase()}',
                                    style: TextStyles.plusJakartaSansBody2
                                        .copyWith(color: Colors.yellow),
                                  ),
                                  // Mostrar campos específicos si están disponibles y no son nulos
                                  if (event.location != null && event.location!.isNotEmpty)
                                    Text(
                                      'Location: ${event.location}',
                                      style: TextStyles.plusJakartaSansBody2,
                                    ),
                                  if (event.subject != null && event.subject!.isNotEmpty)
                                    Text(
                                      'Subject: ${event.subject}',
                                      style: TextStyles.plusJakartaSansBody2,
                                    ),
                                  if (event.withPerson != null && event.withPerson!.isNotEmpty)
                                    Text(
                                      'With Person: ${event.withPerson}',
                                      style: TextStyles.plusJakartaSansBody2,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: TextStyles.plusJakartaSansBody1,
        onChanged: (value) => _searchEvents(), // Trigger search on text change
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyles.plusJakartaSansSubtitle2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromRGBO(105, 240, 174, 1),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          filled: true,
          fillColor: const Color(0xFF1F1F1F),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required Object? value,
    required void Function(Object?)? onChanged,
    required List<DropdownMenuItem<Object>> items,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField(
        value: value,
        onChanged: onChanged,
        items: items,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyles.plusJakartaSansSubtitle2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromRGBO(105, 240, 174, 1),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          filled: true,
          fillColor: const Color(0xFF1F1F1F),
        ),
        style: TextStyles.plusJakartaSansBody2,
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Priority', style: TextStyles.plusJakartaSansSubtitle2),
              const SizedBox(width: 10),
              Switch(
                value: _enablePriorityFilter,
                onChanged: (bool newValue) {
                  setState(() {
                    _enablePriorityFilter = newValue;
                    if (!newValue) {
                      _selectedPriority =
                          null; // Reset priority when switch is off
                    }
                    _searchEvents();
                  });
                },
                activeColor: const Color.fromRGBO(
                  105,
                  240,
                  174,
                  1,
                ).withOpacity(0.8),
                inactiveTrackColor: Colors.grey[600],
                inactiveThumbColor: Colors.grey[350],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Visibility(
            visible: _enablePriorityFilter,
            child: Wrap(
              spacing: 8.0,
              children: [
                _buildPriorityOption(
                  'CRITICAL',
                  Priority.critical,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F),
                ),
                _buildPriorityOption(
                  'HIGH',
                  Priority.high,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F),
                ),
                _buildPriorityOption(
                  'MEDIUM',
                  Priority.medium,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F),
                ),
                _buildPriorityOption(
                  'LOW',
                  Priority.low,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityOption(
    String label,
    Priority priority,
    Color backgroundColor,
    Color textColor,
  ) {
    final isSelected = _selectedPriority == priority;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? textColor : Colors.black87.withOpacity(0.8),
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedPriority = _selectedPriority == priority ? null : priority;
            _searchEvents();
          }
        });
      },
      backgroundColor: backgroundColor.withOpacity(0.3),
      selectedColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      side: BorderSide(color: isSelected ? backgroundColor : Colors.grey[300]!),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildWithPersonField() {
    const secondaryColor = Color.fromRGBO(105, 240, 174, 1);
    const outlineColor = Color(0xFFE0E0E0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "With Person (Yes/No):",
                style: TextStyles.plusJakartaSansBody2,
              ),
              const SizedBox(width: 8.0),
              Checkbox(
                value: _withPersonYesNoSearch,
                onChanged: (bool? value) {
                  setState(() {
                    _withPersonYesNoSearch = value ?? false;
                    _searchEvents();
                  });
                },
                activeColor: secondaryColor.withOpacity(0.7),
                checkColor: const Color(0xFF0F0F0F),
                side: BorderSide(color: outlineColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Visibility(
              visible: _withPersonYesNoSearch,
              child: TextFormField(
                controller: _withPersonSearchController,
                style: TextStyles.plusJakartaSansBody1,
                onChanged: (value) => _searchEvents(), // Trigger search on text change
                decoration: InputDecoration(
                  labelText: 'With Person',
                  labelStyle: TextStyles.plusJakartaSansSubtitle2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: secondaryColor,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
