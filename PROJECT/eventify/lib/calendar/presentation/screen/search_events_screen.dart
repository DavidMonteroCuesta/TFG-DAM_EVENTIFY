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
import 'package:eventify/calendar/presentation/screen/add_event_screen.dart';
import 'package:eventify/common/constants/app_strings.dart'; // Importación de la interfaz de constantes

class EventSearchScreen extends StatefulWidget {
  final DateTime? initialSelectedDate;
  final String? initialSearchTitle; // Nuevo: Título de búsqueda inicial

  const EventSearchScreen({
    super.key,
    this.initialSelectedDate,
    this.initialSearchTitle, // Inicializar el nuevo parámetro
  });

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
  List<Map<String, dynamic>> _searchResults = [];
  late EventViewModel _eventViewModel;
  bool _enablePriorityFilter = false;

  @override
  void initState() {
    super.initState();
    _eventViewModel = sl<EventViewModel>();
    _selectedSearchDate = widget.initialSelectedDate;
    // MODIFIED: Inicializa el controlador del título con el valor inicial
    _titleSearchController.text = widget.initialSearchTitle ?? '';

    _loadEvents();
    _titleSearchController.addListener(_searchEvents);
    _descriptionSearchController.addListener(_searchEvents);
    _locationSearchController.addListener(_searchEvents);
    _subjectSearchController.addListener(_searchEvents);
    _withPersonSearchController.addListener(_searchEvents);
    _searchEvents();
  }

  EventType _getEventTypeFromString(String typeString) {
    switch (typeString.toLowerCase()) {
      case AppStrings.eventTypeMeeting: // Usando constante
        return EventType.meeting;
      case AppStrings.eventTypeExam: // Usando constante
        return EventType.exam;
      case AppStrings.eventTypeConference: // Usando constante
        return EventType.conference;
      case AppStrings.eventTypeAppointment: // Usando constante
        return EventType.appointment;
      case AppStrings.eventTypeTask: // Usando constante
        return EventType.task;
      default:
        return EventType.all;
    }
  }

  Future<void> _loadEvents() async {
    try {
      await _eventViewModel.getEventsForCurrentUser();
      if (mounted) {
        setState(() => _searchResults = _eventViewModel.events);
        _searchEvents();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.searchFailedToLoadEvents}${e.toString()}')), // Usando constante
        );
      }
    }
  }

  Future<void> _selectSearchDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedSearchDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
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
        _searchEvents();
      });
    }
  }

  void _clearSearchDate() {
    setState(() {
      _selectedSearchDate = null;
      _searchEvents();
    });
  }

  void _searchEvents() {
    setState(() {
      List<Map<String, dynamic>> allEventsData = _eventViewModel.events;
      List<Map<String, dynamic>> results = List.from(allEventsData);

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

      if ((_selectedEventType == EventType.meeting ||
              _selectedEventType == EventType.conference ||
              _selectedEventType == EventType.appointment ||
              _selectedEventType == EventType.all) &&
          location.isNotEmpty) {
        results = results.where((eventData) {
          final eventTypeString = eventData['type'] as String?;
          if (eventTypeString == AppStrings.eventTypeMeeting || eventTypeString == AppStrings.eventTypeConference || eventTypeString == AppStrings.eventTypeAppointment) { // Usando constantes
            return (eventData['location'] as String?)?.toLowerCase().contains(location) ?? false;
          }
          return false;
        }).toList();
      }
      if ((_selectedEventType == EventType.exam || _selectedEventType == EventType.all) &&
          subject.isNotEmpty) {
        results = results.where((eventData) {
          final eventTypeString = eventData['type'] as String?;
          if (eventTypeString == AppStrings.eventTypeExam) { // Usando constante
            return (eventData['subject'] as String?)?.toLowerCase().contains(subject) ?? false;
          }
          return false;
        }).toList();
      }
      if ((_selectedEventType == EventType.appointment || _selectedEventType == EventType.all) &&
          _withPersonYesNoSearch) {
        results = results.where((eventData) {
          final eventTypeString = eventData['type'] as String?;
          if (eventTypeString == AppStrings.eventTypeAppointment) { // Usando constante
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

  Future<void> _onEditEvent(Map<String, dynamic> eventData) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEventScreen(eventToEdit: eventData),
      ),
    );

    if (mounted) {
      if (result == true) {
        await _loadEvents();
        _searchEvents();
      }
    }
  }

  Future<void> _onDeleteEvent(Map<String, dynamic> eventData) async {
    final String eventId = eventData['id'] as String;
    final String eventTitle = eventData['title'] as String;

    final bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(AppStrings.searchDeleteEventTitle, style: TextStyles.urbanistSubtitle1.copyWith(color: Colors.white)), // Usando constante
              content: Text('${AppStrings.searchDeleteEventConfirmPrefix}"$eventTitle"${AppStrings.searchDeleteEventConfirmSuffix}', style: TextStyles.plusJakartaSansBody2.copyWith(color: Colors.grey)), // Usando constantes
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppStrings.searchCancelButton, style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: AppColors.primaryContainer)), // Usando constante
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(AppStrings.searchDeleteButton, style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: Colors.red)), // Usando constante
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirm) {
      try {
        await _eventViewModel.deleteEvent(eventId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.searchEventDeletedSuccessPrefix}"$eventTitle"${AppStrings.searchEventDeletedSuccessSuffix}')), // Usando constantes
          );
          await _loadEvents();
          _searchEvents();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.searchFailedToDeleteEvent}${e.toString()}')), // Usando constante
          );
        }
      }
    }
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
          text: AppStrings.searchEventsTitle, // Usando constante
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
                labelText: AppStrings.searchFieldEventTitle, // Usando constante
              ),
              _buildSearchField(
                controller: _descriptionSearchController,
                labelText: AppStrings.searchFieldDescription, // Usando constante
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () => _selectSearchDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppStrings.searchFieldDate, // Usando constante
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
                          : AppStrings.searchFieldSelectDate, // Usando constante
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
                              ? AppStrings.eventTypeAll // Usando constante
                              : value.toString().split('.').last.toUpperCase(),
                          style: TextStyles.plusJakartaSansBody2,
                        ),
                      );
                    }).toList(),
                labelText: AppStrings.searchFieldEventType, // Usando constante
              ),
              _buildPrioritySelector(),
              if (_selectedEventType == EventType.meeting ||
                  _selectedEventType == EventType.conference ||
                  _selectedEventType == EventType.appointment ||
                  _selectedEventType == EventType.all)
                _buildSearchField(
                  controller: _locationSearchController,
                  labelText: AppStrings.searchFieldLocation, // Usando constante
                ),
              if (_selectedEventType == EventType.exam || _selectedEventType == EventType.all)
                _buildSearchField(
                  controller: _subjectSearchController,
                  labelText: AppStrings.searchFieldSubject, // Usando constante
                ),
              if (_selectedEventType == EventType.appointment || _selectedEventType == EventType.all)
                _buildWithPersonField(),

              if (_searchResults.isNotEmpty) ...[
                const SizedBox(height: 10.0),
                Text(
                  '${AppStrings.searchResultsPrefix}${_searchResults.length}${AppStrings.searchResultsSuffix}', // Usando constantes
                  style: TextStyles.urbanistSubtitle1.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _searchResults.map((eventData) {
                        final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
                        if (currentUserId == null) {
                          return const SizedBox.shrink();
                        }
                        final Event event = EventFactory.createEvent(
                          _getEventTypeFromString(eventData['type'] ?? AppStrings.eventTypeTask), // Usando constante
                          eventData,
                          currentUserId,
                        );

                        String eventTypeString = AppStrings.searchNA; // Usando constante
                        if (event is MeetingEvent) {
                          eventTypeString = AppStrings.searchEventTypeMeetingDisplay; // Usando constante
                        } else if (event is ExamEvent) {
                          eventTypeString = AppStrings.searchEventTypeExamDisplay; // Usando constante
                        } else if (event is ConferenceEvent) {
                          eventTypeString = AppStrings.searchEventTypeConferenceDisplay; // Usando constante
                        } else if (event is AppointmentEvent) {
                          eventTypeString = AppStrings.searchEventTypeAppointmentDisplay; // Usando constante
                        } else {
                          eventTypeString = AppStrings.searchEventTypeTaskDisplay; // Usando constante
                        }
                        String formattedDateTime =
                            event.dateTime != null
                                ? DateFormat(
                                  'yyyy/MM/dd HH:mm',
                                ).format(event.dateTime!.toDate())
                                : AppStrings.searchNA; // Usando constante

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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          event.title,
                                          style: TextStyles.plusJakartaSansBody1
                                              .copyWith(fontSize: 18),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                            onPressed: () => _onEditEvent(eventData),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                                            onPressed: () => _onDeleteEvent(eventData),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '${AppStrings.searchDateAndTimePrefix}$formattedDateTime', // Usando constante
                                    style: TextStyles.plusJakartaSansBody2,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '${AppStrings.searchTypePrefix}$eventTypeString', // Usando constante
                                    style: TextStyles.plusJakartaSansBody2,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '${AppStrings.searchDescriptionPrefix}${event.description ?? AppStrings.searchNA}', // Usando constante
                                    style: TextStyles.plusJakartaSansBody2,
                                  ),
                                  Text(
                                    '${AppStrings.searchPriorityPrefix}${event.priority.toString().split('.').last.toUpperCase()}', // Usando constante
                                    style: TextStyles.plusJakartaSansBody2
                                        .copyWith(color: Colors.yellow),
                                  ),
                                  if (event.location != null && event.location!.isNotEmpty)
                                    Text(
                                      '${AppStrings.searchLocationPrefix}${event.location}', // Usando constante
                                      style: TextStyles.plusJakartaSansBody2,
                                    ),
                                  if (event.subject != null && event.subject!.isNotEmpty)
                                    Text(
                                      '${AppStrings.searchSubjectPrefix}${event.subject}', // Usando constante
                                      style: TextStyles.plusJakartaSansBody2,
                                    ),
                                  if (event.withPerson != null && event.withPerson!.isNotEmpty)
                                    Text(
                                      '${AppStrings.searchWithPersonPrefix}${event.withPerson}', // Usando constante
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
        onChanged: (value) => _searchEvents(),
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
              Text(AppStrings.searchFieldPriority, style: TextStyles.plusJakartaSansSubtitle2), // Usando constante
              const SizedBox(width: 10),
              Switch(
                value: _enablePriorityFilter,
                onChanged: (bool newValue) {
                  setState(() {
                    _enablePriorityFilter = newValue;
                    if (!newValue) {
                      _selectedPriority = null;
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
                  AppStrings.searchPriorityCritical, // Usando constante
                  Priority.critical,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F),
                ),
                _buildPriorityOption(
                  AppStrings.searchPriorityHigh, // Usando constante
                  Priority.high,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F),
                ),
                _buildPriorityOption(
                  AppStrings.searchPriorityMedium, // Usando constante
                  Priority.medium,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F),
                ),
                _buildPriorityOption(
                  AppStrings.searchPriorityLow, // Usando constante
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
                AppStrings.searchFieldWithPersonYesNo, // Usando constante
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
                onChanged: (value) => _searchEvents(),
                decoration: InputDecoration(
                  labelText: AppStrings.searchFieldWithPerson, // Usando constante
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
