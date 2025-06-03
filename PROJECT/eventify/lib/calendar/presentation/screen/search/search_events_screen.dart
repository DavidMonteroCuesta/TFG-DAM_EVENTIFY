// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/calendar/presentation/screen/add_event/add_event_screen.dart';
import 'package:eventify/calendar/presentation/screen/search/logic/event_type_logic.dart';
import 'package:eventify/calendar/presentation/screen/search/logic/priority_logic.dart';
import 'package:eventify/calendar/presentation/screen/search/logic/search_date_logic.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/event_result_card.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/fields/date_picker_field.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/fields/dropdown_field.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/fields/with_person_field.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/priority_selector.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/search_field.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/search_results_list.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/di/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventSearchScreen extends StatefulWidget {
  final DateTime? initialSelectedDate;
  final String? initialSearchTitle;

  const EventSearchScreen({
    super.key,
    this.initialSelectedDate,
    this.initialSearchTitle,
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

  static const double _headerHeight = kToolbarHeight;
  static const double _formHorizontalPadding = 20.0;
  static const double _resultsSpacing = 10.0;
  static const double _resultsFontSize = 18.0;
  static const double _headerBlurSigma = 18.0;
  static const double _headerOpacity = 0.2;
  static const double _headerIconWidth = 48.0;

  @override
  void initState() {
    super.initState();
    _eventViewModel = sl<EventViewModel>();
    _selectedSearchDate = widget.initialSelectedDate;
    _titleSearchController.text = widget.initialSearchTitle ?? '';

    _loadEvents();
    _titleSearchController.addListener(_searchEvents);
    _descriptionSearchController.addListener(_searchEvents);
    _locationSearchController.addListener(_searchEvents);
    _subjectSearchController.addListener(_searchEvents);
    _withPersonSearchController.addListener(_searchEvents);
    _searchEvents();
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
          SnackBar(
            content: Text(
              '${AppInternalConstants.searchFailedToLoadEvents}${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  Future<void> _selectSearchDate(BuildContext context) async {
    final DateTime? picked = await SearchDateLogic.selectSearchDate(
      context: context,
      initialDate: _selectedSearchDate,
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

      results = _filterByTitle(results);
      results = _filterByDescription(results);
      results = _filterByDate(results);
      results = _filterByEventType(results);
      results = _filterByPriority(results);
      results = _filterByLocation(results);
      results = _filterBySubject(results);
      results = _filterByWithPerson(results);

      _searchResults = results;
    });
  }

  // Filtra los eventos por título
  List<Map<String, dynamic>> _filterByTitle(List<Map<String, dynamic>> events) {
    final title = _titleSearchController.text.toLowerCase();
    if (title.isNotEmpty) {
      return events.where((eventData) {
        return (eventData[AppFirestoreFields.title] as String?)
                ?.toLowerCase()
                .contains(title) ??
            false;
      }).toList();
    }
    return events;
  }

  // Filtra los eventos por descripción
  List<Map<String, dynamic>> _filterByDescription(
    List<Map<String, dynamic>> events,
  ) {
    final description = _descriptionSearchController.text.toLowerCase();
    if (description.isNotEmpty) {
      return events.where((eventData) {
        return (eventData[AppFirestoreFields.description] as String?)
                ?.toLowerCase()
                .contains(description) ??
            false;
      }).toList();
    }
    return events;
  }

  // Filtra los eventos por fecha seleccionada
  List<Map<String, dynamic>> _filterByDate(List<Map<String, dynamic>> events) {
    if (_selectedSearchDate != null) {
      return events.where((eventData) {
        final Timestamp? eventTimestamp =
            eventData[AppFirestoreFields.dateTime];
        if (eventTimestamp != null) {
          return eventTimestamp.toDate().year == _selectedSearchDate!.year &&
              eventTimestamp.toDate().month == _selectedSearchDate!.month &&
              eventTimestamp.toDate().day == _selectedSearchDate!.day;
        }
        return false;
      }).toList();
    }
    return events;
  }

  // Filtra los eventos por tipo
  List<Map<String, dynamic>> _filterByEventType(
    List<Map<String, dynamic>> events,
  ) {
    if (_selectedEventType != EventType.all) {
      return events.where((eventData) {
        final eventTypeString = eventData[AppFirestoreFields.type] as String?;
        if (eventTypeString == null) return false;

        final EventType eventType = EventTypeLogic.getEventTypeFromString(
          eventTypeString,
        );
        return eventType == _selectedEventType;
      }).toList();
    }
    return events;
  }

  // Filtra los eventos por prioridad
  List<Map<String, dynamic>> _filterByPriority(
    List<Map<String, dynamic>> events,
  ) {
    if (_enablePriorityFilter && _selectedPriority != null) {
      return events.where((eventData) {
        final priorityString =
            eventData[AppFirestoreFields.priority] as String?;
        if (priorityString == null) return false;
        return PriorityConverter.stringToPriority(priorityString) ==
            _selectedPriority;
      }).toList();
    }
    return events;
  }

  // Filtra los eventos por localización
  List<Map<String, dynamic>> _filterByLocation(
    List<Map<String, dynamic>> events,
  ) {
    final location = _locationSearchController.text.toLowerCase();
    if ((_selectedEventType == EventType.meeting ||
            _selectedEventType == EventType.conference ||
            _selectedEventType == EventType.appointment ||
            _selectedEventType == EventType.all) &&
        location.isNotEmpty) {
      return events.where((eventData) {
        final eventTypeString = eventData[AppFirestoreFields.type] as String?;
        if (eventTypeString == AppFirestoreFields.typeMeeting ||
            eventTypeString == AppFirestoreFields.typeConference ||
            eventTypeString == AppFirestoreFields.typeAppointment) {
          return (eventData[AppFirestoreFields.location] as String?)
                  ?.toLowerCase()
                  .contains(location) ??
              false;
        }
        return false;
      }).toList();
    }
    return events;
  }

  // Filtra los eventos por asignatura
  List<Map<String, dynamic>> _filterBySubject(
    List<Map<String, dynamic>> events,
  ) {
    final subject = _subjectSearchController.text.toLowerCase();
    if ((_selectedEventType == EventType.exam ||
            _selectedEventType == EventType.all) &&
        subject.isNotEmpty) {
      return events.where((eventData) {
        final eventTypeString = eventData[AppFirestoreFields.type] as String?;
        if (eventTypeString == AppFirestoreFields.typeExam) {
          return (eventData[AppFirestoreFields.subject] as String?)
                  ?.toLowerCase()
                  .contains(subject) ??
              false;
        }
        return false;
      }).toList();
    }
    return events;
  }

  // Filtra los eventos por persona asociada (para citas)
  List<Map<String, dynamic>> _filterByWithPerson(
    List<Map<String, dynamic>> events,
  ) {
    final withPerson = _withPersonSearchController.text.toLowerCase();
    if ((_selectedEventType == EventType.appointment ||
            _selectedEventType == EventType.all) &&
        _withPersonYesNoSearch) {
      return events.where((eventData) {
        final eventTypeString = eventData[AppFirestoreFields.type] as String?;
        if (eventTypeString == AppFirestoreFields.typeAppointment) {
          final bool withPersonYesNo =
              eventData[AppFirestoreFields.withPersonYesNo] ?? false;
          final String? eventWithPerson =
              eventData[AppFirestoreFields.withPerson];
          return withPersonYesNo &&
              (eventWithPerson?.toLowerCase().contains(withPerson) ?? false);
        }
        return false;
      }).toList();
    }
    return events;
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
    final String eventId = eventData[AppFirestoreFields.id] as String;
    final String eventTitle = eventData[AppFirestoreFields.title] as String;

    final bool confirm = await _showDeleteConfirmationDialog(eventTitle);

    if (confirm) {
      await _deleteEvent(eventId, eventTitle);
    }
  }

  Future<bool> _showDeleteConfirmationDialog(String eventTitle) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.dialogBackground,
              title: Text(
                AppStrings.searchDeleteEventTitle(context),
                style: TextStyles.urbanistSubtitle1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              content: Text(
                '${AppStrings.searchDeleteEventConfirmPrefix(context)}"$eventTitle"${AppStrings.searchDeleteEventConfirmSuffix(context)}',
                style: TextStyles.plusJakartaSansBody2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    AppStrings.searchCancelButton(context),
                    style: TextStyles.plusJakartaSansSubtitle2.copyWith(
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    AppStrings.searchDeleteButton(context),
                    style: TextStyles.plusJakartaSansSubtitle2.copyWith(
                      color: AppColors.deleteButtonColor,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _deleteEvent(String eventId, String eventTitle) async {
    try {
      await _eventViewModel.deleteEvent(eventId);
      if (mounted) {
        await _loadEvents();
        _searchEvents();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar(e);
      }
    }
  }

  void _showErrorSnackbar(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppInternalConstants.searchFailedToDeleteEvent}${error.toString()}',
        ),
      ),
    );
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              _formHorizontalPadding,
              _headerHeight,
              _formHorizontalPadding,
              0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchField(
                    controller: _titleSearchController,
                    labelText: AppStrings.searchFieldEventTitle(context),
                    onChanged: (_) => _searchEvents(),
                  ),
                  SearchField(
                    controller: _descriptionSearchController,
                    labelText: AppStrings.searchFieldDescription(context),
                    onChanged: (_) => _searchEvents(),
                  ),
                  DatePickerField(
                    selectedDate: _selectedSearchDate,
                    onTap: () => _selectSearchDate(context),
                    onClear:
                        _selectedSearchDate != null ? _clearSearchDate : null,
                    contextForStrings: context,
                  ),
                  DropdownField<EventType>(
                    value: _selectedEventType,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedEventType = newValue;
                          _searchEvents();
                        });
                      }
                    },
                    items:
                        EventType.values.map((value) {
                          return DropdownMenuItem<EventType>(
                            value: value,
                            child: Text(
                              EventTypeLogic.getTranslatedEventTypeDisplay(
                                value,
                                context,
                              ),
                              style: TextStyles.plusJakartaSansBody2,
                            ),
                          );
                        }).toList(),
                    labelText: AppStrings.searchFieldEventType(context),
                  ),
                  PrioritySelector(
                    enablePriorityFilter: _enablePriorityFilter,
                    onEnableChanged: (newValue) {
                      setState(() {
                        _enablePriorityFilter = newValue;
                        if (!newValue) _selectedPriority = null;
                        _searchEvents();
                      });
                    },
                    selectedPriority: _selectedPriority,
                    onPriorityChanged: (priority) {
                      setState(() {
                        _selectedPriority = priority;
                        _searchEvents();
                      });
                    },
                    labelCritical: AppStrings.searchPriorityCritical(context),
                    labelHigh: AppStrings.searchPriorityHigh(context),
                    labelMedium: AppStrings.searchPriorityMedium(context),
                    labelLow: AppStrings.searchPriorityLow(context),
                  ),
                  if (_selectedEventType == EventType.meeting ||
                      _selectedEventType == EventType.conference ||
                      _selectedEventType == EventType.appointment ||
                      _selectedEventType == EventType.all)
                    SearchField(
                      controller: _locationSearchController,
                      labelText: AppStrings.searchFieldLocation(context),
                      onChanged: (_) => _searchEvents(),
                    ),
                  if (_selectedEventType == EventType.exam ||
                      _selectedEventType == EventType.all)
                    SearchField(
                      controller: _subjectSearchController,
                      labelText: AppStrings.searchFieldSubject(context),
                      onChanged: (_) => _searchEvents(),
                    ),
                  if (_selectedEventType == EventType.appointment ||
                      _selectedEventType == EventType.all)
                    WithPersonField(
                      withPersonYesNoSearch: _withPersonYesNoSearch,
                      onChanged: (newValue) {
                        setState(() {
                          _withPersonYesNoSearch = newValue ?? false;
                          _searchEvents();
                        });
                      },
                      controller: _withPersonSearchController,
                      labelText: AppStrings.searchFieldWithPerson(context),
                      yesNoLabel: AppStrings.searchFieldWithPersonYesNo(
                        context,
                      ),
                    ),
                  if ((_selectedEventType == EventType.appointment ||
                          _selectedEventType == EventType.all) &&
                      _withPersonYesNoSearch)
                    SearchField(
                      controller: _withPersonSearchController,
                      labelText: AppStrings.searchFieldWithPerson(context),
                      onChanged: (_) => _searchEvents(),
                    ),
                  if (_searchResults.isNotEmpty) ...[
                    const SizedBox(height: _resultsSpacing),
                    Text(
                      '${AppStrings.searchResultsPrefix(context)}${_searchResults.length}${AppStrings.searchResultsSuffix(context)}',
                      style: TextStyles.urbanistSubtitle1.copyWith(
                        fontSize: _resultsFontSize,
                      ),
                    ),
                    const SizedBox(height: _resultsSpacing),
                    SearchResultsList(
                      children:
                          _searchResults.map((eventData) {
                            final String? currentUserId =
                                FirebaseAuth.instance.currentUser?.uid;
                            if (currentUserId == null) {
                              return const SizedBox.shrink();
                            }
                            final Event event = EventFactory.createEvent(
                              EventTypeLogic.getEventTypeFromString(
                                eventData[AppFirestoreFields.type] ??
                                    AppFirestoreFields.typeTask,
                              ),
                              eventData,
                              currentUserId,
                            );
                            String eventTypeString =
                                EventTypeLogic.getTranslatedEventTypeDisplay(
                                  EventTypeLogic.getEventTypeFromString(
                                    eventData[AppFirestoreFields.type] ??
                                        AppFirestoreFields.typeTask,
                                  ),
                                  context,
                                );
                            String formattedDateTime =
                                event.dateTime != null
                                    ? DateFormat(
                                      'yyyy/MM/dd HH:mm',
                                    ).format(event.dateTime!.toDate())
                                    : AppInternalConstants.searchNA;
                            return EventResultCard(
                              event: event,
                              eventTypeString: eventTypeString,
                              formattedDateTime: formattedDateTime,
                              getTranslatedPriorityDisplay:
                                  (priorityString) =>
                                      PriorityLogic.getTranslatedPriorityDisplay(
                                        priorityString,
                                        context,
                                      ),
                              onEdit: () => _onEditEvent(eventData),
                              onDelete: () => _onDeleteEvent(eventData),
                              width: screenWidth * 0.9,
                              contextForStrings: context,
                            );
                          }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _headerBlurSigma,
                sigmaY: _headerBlurSigma,
              ),
              child: Container(
                width: double.infinity,
                height: _headerHeight,
                color: AppColors.headerBackground.withOpacity(_headerOpacity),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.outlineColorLight,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: ShiningTextAnimation(
                          text: AppStrings.searchEventsTitle(context),
                          style: TextStyles.urbanistBody1,
                          shineColor: AppColors.shineColorLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: _headerIconWidth),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
