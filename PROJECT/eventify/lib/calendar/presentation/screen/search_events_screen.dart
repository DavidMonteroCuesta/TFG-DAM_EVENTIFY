import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:eventify/calendar/presentation/screen/add_event_screen.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';

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
        return EventType.task;
      default:
        return EventType.all;
    }
  }

  String _getTranslatedEventTypeDisplay(EventType type) {
    switch (type) {
      case EventType.meeting:
        return AppStrings.searchEventTypeMeetingDisplay(context);
      case EventType.exam:
        return AppStrings.searchEventTypeExamDisplay(context);
      case EventType.conference:
        return AppStrings.searchEventTypeConferenceDisplay(context);
      case EventType.appointment:
        return AppStrings.searchEventTypeAppointmentDisplay(context);
      case EventType.task:
        return AppStrings.searchEventTypeTaskDisplay(context);
      case EventType.all:
        return AppStrings.searchEventTypeAllDisplay(context);
    }
  }

  // Helper function to get translated priority for display and convert to uppercase
  String _getTranslatedPriorityDisplay(String priorityString) {
    switch (priorityString.toLowerCase()) {
      case AppInternalConstants.priorityValueCritical:
        return AppStrings.priorityDisplayCritical(context).toUpperCase();
      case AppInternalConstants.priorityValueHigh:
        return AppStrings.priorityDisplayHigh(context).toUpperCase();
      case AppInternalConstants.priorityValueMedium:
        return AppStrings.priorityDisplayMedium(context).toUpperCase();
      case AppInternalConstants.priorityValueLow:
        return AppStrings.priorityDisplayLow(context).toUpperCase();
      default:
        return priorityString.toUpperCase();
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
          SnackBar(content: Text('${AppInternalConstants.searchFailedToLoadEvents}${e.toString()}')),
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
          if (eventTypeString == AppInternalConstants.eventTypeMeeting || eventTypeString == AppInternalConstants.eventTypeConference || eventTypeString == AppInternalConstants.eventTypeAppointment) {
            return (eventData['location'] as String?)?.toLowerCase().contains(location) ?? false;
          }
          return false;
        }).toList();
      }
      if ((_selectedEventType == EventType.exam || _selectedEventType == EventType.all) &&
          subject.isNotEmpty) {
        results = results.where((eventData) {
          final eventTypeString = eventData['type'] as String?;
          if (eventTypeString == AppInternalConstants.eventTypeExam) {
            return (eventData['subject'] as String?)?.toLowerCase().contains(subject) ?? false;
          }
          return false;
        }).toList();
      }
      if ((_selectedEventType == EventType.appointment || _selectedEventType == EventType.all) &&
          _withPersonYesNoSearch) {
        results = results.where((eventData) {
          final eventTypeString = eventData['type'] as String?;
          if (eventTypeString == AppInternalConstants.eventTypeAppointment) {
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
              backgroundColor: AppColors.dialogBackground,
              title: Text(AppStrings.searchDeleteEventTitle(context), style: TextStyles.urbanistSubtitle1.copyWith(color: AppColors.textPrimary)),
              content: Text('${AppStrings.searchDeleteEventConfirmPrefix(context)}"$eventTitle"${AppStrings.searchDeleteEventConfirmSuffix(context)}', style: TextStyles.plusJakartaSansBody2.copyWith(color: AppColors.textSecondary)),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppStrings.searchCancelButton(context), style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: AppColors.primaryContainer)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(AppStrings.searchDeleteButton(context), style: TextStyles.plusJakartaSansSubtitle2.copyWith(color: AppColors.deleteButtonColor)),
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
            SnackBar(content: Text('${AppStrings.searchEventDeletedSuccessPrefix(context)}"$eventTitle"${AppStrings.searchEventDeletedSuccessSuffix(context)}')),
          );
          await _loadEvents();
          _searchEvents();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppInternalConstants.searchFailedToDeleteEvent}${e.toString()}')),
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
          icon: const Icon(Icons.arrow_back, color: AppColors.outlineColorLight),
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
              _buildSearchField(
                controller: _titleSearchController,
                labelText: AppStrings.searchFieldEventTitle(context),
              ),
              _buildSearchField(
                controller: _descriptionSearchController,
                labelText: AppStrings.searchFieldDescription(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () => _selectSearchDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppStrings.searchFieldDate(context),
                      labelStyle: TextStyles.plusJakartaSansSubtitle2,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: AppColors.focusedBorderGreen,
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
                      fillColor: AppColors.inputFillColor,
                      suffixIcon:
                          _selectedSearchDate != null
                              ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: _clearSearchDate,
                              )
                              : const Icon(
                                Icons.calendar_today,
                                color: AppColors.textSecondary,
                              ),
                    ),
                    child: Text(
                      _selectedSearchDate != null
                          ? DateFormat(
                            'yyyy-MM-dd',
                          ).format(_selectedSearchDate!)
                          : AppStrings.searchFieldSelectDate(context),
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
                          _getTranslatedEventTypeDisplay(value),
                          style: TextStyles.plusJakartaSansBody2,
                        ),
                      );
                    }).toList(),
                labelText: AppStrings.searchFieldEventType(context),
              ),
              _buildPrioritySelector(),
              if (_selectedEventType == EventType.meeting ||
                  _selectedEventType == EventType.conference ||
                  _selectedEventType == EventType.appointment ||
                  _selectedEventType == EventType.all)
                _buildSearchField(
                  controller: _locationSearchController,
                  labelText: AppStrings.searchFieldLocation(context),
                ),
              if (_selectedEventType == EventType.exam || _selectedEventType == EventType.all)
                _buildSearchField(
                  controller: _subjectSearchController,
                  labelText: AppStrings.searchFieldSubject(context),
                ),
              if (_selectedEventType == EventType.appointment || _selectedEventType == EventType.all)
                _buildWithPersonField(),

              if (_searchResults.isNotEmpty) ...[
                const SizedBox(height: 10.0),
                Text(
                  '${AppStrings.searchResultsPrefix(context)}${_searchResults.length}${AppStrings.searchResultsSuffix(context)}',
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
                          _getEventTypeFromString(eventData['type'] ?? AppInternalConstants.eventTypeTask),
                          eventData,
                          currentUserId,
                        );

                        String eventTypeString = _getTranslatedEventTypeDisplay(_getEventTypeFromString(eventData['type'] ?? AppInternalConstants.eventTypeTask));
                        String formattedDateTime =
                            event.dateTime != null
                                ? DateFormat(
                                  'yyyy/MM/dd HH:mm',
                                ).format(event.dateTime!.toDate())
                                : AppInternalConstants.searchNA;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: screenWidth * 0.9,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: AppColors.outlineColorLight.withOpacity(0.3),
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
                                            icon: const Icon(Icons.edit, color: AppColors.editIconColor),
                                            onPressed: () => _onEditEvent(eventData),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: AppColors.deleteIconColor),
                                            onPressed: () => _onDeleteEvent(eventData),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '${AppStrings.searchDateAndTimePrefix(context)}$formattedDateTime',
                                    style: TextStyles.plusJakartaSansBody2,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '${AppStrings.searchTypePrefix(context)}$eventTypeString',
                                    style: TextStyles.plusJakartaSansBody2,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '${AppStrings.searchDescriptionPrefix(context)}${event.description ?? AppInternalConstants.searchNA}',
                                    style: TextStyles.plusJakartaSansBody2,
                                  ),
                                  Text(
                                    '${AppStrings.searchPriorityPrefix(context)}${_getTranslatedPriorityDisplay(event.priority.toString().split('.').last)}',
                                    style: TextStyles.plusJakartaSansBody2
                                        .copyWith(color: AppColors.priorityTextColor),
                                  ),
                                  if (event.location != null && event.location!.isNotEmpty)
                                    Text(
                                      '${AppStrings.searchLocationPrefix(context)}${event.location}',
                                      style: TextStyles.plusJakartaSansBody2,
                                    ),
                                  if (event.subject != null && event.subject!.isNotEmpty)
                                    Text(
                                      '${AppStrings.searchSubjectPrefix(context)}${event.subject}',
                                      style: TextStyles.plusJakartaSansBody2,
                                    ),
                                  if (event.withPerson != null && event.withPerson!.isNotEmpty)
                                    Text(
                                      '${AppStrings.searchWithPersonPrefix(context)}${event.withPerson}',
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
              color: AppColors.focusedBorderGreen,
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
          fillColor: AppColors.inputFillColor,
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
              color: AppColors.focusedBorderGreen,
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
          fillColor: AppColors.inputFillColor,
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
              Text(AppStrings.searchFieldPriority(context), style: TextStyles.plusJakartaSansSubtitle2),
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
                activeColor: AppColors.focusedBorderGreen.withOpacity(0.8),
                inactiveTrackColor: AppColors.switchInactiveTrackColor,
                inactiveThumbColor: AppColors.switchInactiveThumbColor,
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
                  AppStrings.searchPriorityCritical(context),
                  Priority.critical,
                  AppColors.focusedBorderGreen.withOpacity(0.8),
                  AppColors.priorityOptionBackground,
                ),
                _buildPriorityOption(
                  AppStrings.searchPriorityHigh(context),
                  Priority.high,
                  AppColors.focusedBorderGreen.withOpacity(0.8),
                  AppColors.priorityOptionBackground,
                ),
                _buildPriorityOption(
                  AppStrings.searchPriorityMedium(context),
                  Priority.medium,
                  AppColors.focusedBorderGreen.withOpacity(0.8),
                  AppColors.priorityOptionBackground,
                ),
                _buildPriorityOption(
                  AppStrings.searchPriorityLow(context),
                  Priority.low,
                  AppColors.focusedBorderGreen.withOpacity(0.8),
                  AppColors.priorityOptionBackground,
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
          color: isSelected ? textColor : AppColors.priorityOptionSelectedTextColor,
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
      side: BorderSide(color: isSelected ? backgroundColor : AppColors.choiceChipBorderColor),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildWithPersonField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.searchFieldWithPersonYesNo(context),
                style: TextStyles.plusJakartaSansBody1.copyWith(
                  fontSize: 16.0,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8.0),
              Checkbox(
                value: _withPersonYesNoSearch,
                onChanged: (bool? newValue) {
                  setState(() {
                    _withPersonYesNoSearch = newValue ?? false;
                    _searchEvents();
                  });
                },
                activeColor: AppColors.focusedBorderGreen,
                checkColor: AppColors.checkboxCheckColor,
              ),
            ],
          ),
          Visibility(
            visible: _withPersonYesNoSearch,
            child: _buildSearchField(
              controller: _withPersonSearchController,
              labelText: AppStrings.searchFieldWithPerson(context),
            ),
          ),
        ],
      ),
    );
  }
}
