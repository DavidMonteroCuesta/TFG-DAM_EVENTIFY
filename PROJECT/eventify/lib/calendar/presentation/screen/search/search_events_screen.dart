import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/fields/date_picker_field.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:eventify/calendar/presentation/screen/add_event/add_event_screen.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/fields/dropdown_field.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/priority_selector.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/fields/with_person_field.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/search_results_list.dart';
import 'package:eventify/calendar/presentation/screen/search/logic/search_date_logic.dart';
import 'package:eventify/calendar/presentation/screen/search/logic/event_type_logic.dart';
import 'package:eventify/calendar/presentation/screen/search/logic/priority_logic.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/event_result_card.dart';
import 'package:eventify/calendar/presentation/screen/search/widgets/search_field.dart';

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

      final title = _titleSearchController.text.toLowerCase();
      final description = _descriptionSearchController.text.toLowerCase();
      final location = _locationSearchController.text.toLowerCase();
      final subject = _subjectSearchController.text.toLowerCase();
      final withPerson = _withPersonSearchController.text.toLowerCase();

      if (title.isNotEmpty) {
        results =
            results
                .where(
                  (eventData) =>
                      (eventData['title'] as String?)?.toLowerCase().contains(
                        title,
                      ) ??
                      false,
                )
                .toList();
      }
      if (description.isNotEmpty) {
        results =
            results
                .where(
                  (eventData) =>
                      (eventData['description'] as String?)
                          ?.toLowerCase()
                          .contains(description) ??
                      false,
                )
                .toList();
      }
      if (_selectedSearchDate != null) {
        results =
            results.where((eventData) {
              final Timestamp? eventTimestamp = eventData['dateTime'];
              if (eventTimestamp != null) {
                return eventTimestamp.toDate().year ==
                        _selectedSearchDate!.year &&
                    eventTimestamp.toDate().month ==
                        _selectedSearchDate!.month &&
                    eventTimestamp.toDate().day == _selectedSearchDate!.day;
              }
              return false;
            }).toList();
      }
      if (_selectedEventType != EventType.all) {
        results =
            results.where((eventData) {
              final eventTypeString = eventData['type'] as String?;
              if (eventTypeString == null) return false;

              final EventType eventType = EventTypeLogic.getEventTypeFromString(
                eventTypeString,
              );
              return eventType == _selectedEventType;
            }).toList();
      }
      if (_enablePriorityFilter && _selectedPriority != null) {
        results =
            results.where((eventData) {
              final priorityString = eventData['priority'] as String?;
              if (priorityString == null) return false;
              return PriorityConverter.stringToPriority(priorityString) ==
                  _selectedPriority;
            }).toList();
      }

      if ((_selectedEventType == EventType.meeting ||
              _selectedEventType == EventType.conference ||
              _selectedEventType == EventType.appointment ||
              _selectedEventType == EventType.all) &&
          location.isNotEmpty) {
        results =
            results.where((eventData) {
              final eventTypeString = eventData['type'] as String?;
              if (eventTypeString == AppInternalConstants.eventTypeMeeting ||
                  eventTypeString == AppInternalConstants.eventTypeConference ||
                  eventTypeString ==
                      AppInternalConstants.eventTypeAppointment) {
                return (eventData['location'] as String?)
                        ?.toLowerCase()
                        .contains(location) ??
                    false;
              }
              return false;
            }).toList();
      }
      if ((_selectedEventType == EventType.exam ||
              _selectedEventType == EventType.all) &&
          subject.isNotEmpty) {
        results =
            results.where((eventData) {
              final eventTypeString = eventData['type'] as String?;
              if (eventTypeString == AppInternalConstants.eventTypeExam) {
                return (eventData['subject'] as String?)
                        ?.toLowerCase()
                        .contains(subject) ??
                    false;
              }
              return false;
            }).toList();
      }
      if ((_selectedEventType == EventType.appointment ||
              _selectedEventType == EventType.all) &&
          _withPersonYesNoSearch) {
        results =
            results.where((eventData) {
              final eventTypeString = eventData['type'] as String?;
              if (eventTypeString ==
                  AppInternalConstants.eventTypeAppointment) {
                final bool withPersonYesNo =
                    eventData['withPersonYesNo'] ?? false;
                final String? eventWithPerson = eventData['withPerson'];
                return withPersonYesNo &&
                    (eventWithPerson?.toLowerCase().contains(withPerson) ??
                        false);
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

    final bool confirm =
        await showDialog(
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

    if (confirm) {
      try {
        await _eventViewModel.deleteEvent(eventId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppStrings.searchEventDeletedSuccessPrefix(context)}"$eventTitle"${AppStrings.searchEventDeletedSuccessSuffix(context)}',
              ),
            ),
          );
          await _loadEvents();
          _searchEvents();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppInternalConstants.searchFailedToDeleteEvent}${e.toString()}',
              ),
            ),
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.outlineColorLight,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: ShiningTextAnimation(
          text: AppStrings.searchEventsTitle(context),
          style: TextStyles.urbanistBody1,
          shineColor: AppColors.shineColorLight,
        ),
        backgroundColor: AppColors.headerBackground,
        foregroundColor: AppColors.outlineColorLight,
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
                onClear: _selectedSearchDate != null ? _clearSearchDate : null,
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
                  yesNoLabel: AppStrings.searchFieldWithPersonYesNo(context),
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
                const SizedBox(height: 10.0),
                Text(
                  '${AppStrings.searchResultsPrefix(context)}${_searchResults.length}${AppStrings.searchResultsSuffix(context)}',
                  style: TextStyles.urbanistSubtitle1.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10.0),
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
                            eventData['type'] ??
                                AppInternalConstants.eventTypeTask,
                          ),
                          eventData,
                          currentUserId,
                        );
                        String eventTypeString =
                            EventTypeLogic.getTranslatedEventTypeDisplay(
                              EventTypeLogic.getEventTypeFromString(
                                eventData['type'] ??
                                    AppInternalConstants.eventTypeTask,
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
    );
  }
}
