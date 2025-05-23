import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/calendar/presentation/screen/calendar_screen.dart';
import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/di/service_locator.dart';
import 'package:eventify/common/constants/app_strings.dart'; // Importación de la interfaz de constantes

class AddEventScreen extends StatefulWidget {
  final Map<String, dynamic>? eventToEdit;

  const AddEventScreen({super.key, this.eventToEdit});
  static const String routeName = '/add-event';

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Priority _selectedPriority = Priority.medium;
  bool _hasNotification = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Timestamp? _selectedDateTime;
  EventType _selectedEventType = EventType.task;
  final _locationController = TextEditingController();
  final _subjectController = TextEditingController();
  final _withPersonController = TextEditingController();
  bool _withPersonYesNo = false;
  late final EventViewModel _eventViewModel;

  @override
  void initState() {
    super.initState();
    _eventViewModel = sl<EventViewModel>();
    _selectedDate = DateTime.now();
    _selectedTime = const TimeOfDay(hour: 1, minute: 0);
    _updateDateTime();

    if (widget.eventToEdit != null) {
      final eventData = widget.eventToEdit!;
      _titleController.text = eventData['title'] ?? '';
      _descriptionController.text = eventData['description'] ?? '';
      _selectedPriority = PriorityConverter.stringToPriority(eventData['priority']);
      _hasNotification = eventData['hasNotification'] ?? false;

      final Timestamp? eventTimestamp = eventData['dateTime'];
      if (eventTimestamp != null) {
        _selectedDate = eventTimestamp.toDate();
        _selectedTime = TimeOfDay.fromDateTime(eventTimestamp.toDate());
      }
      _selectedEventType = _getEventTypeFromString(eventData['type']);

      // Using constants for event type checks
      if (eventData['type'] == AppStrings.eventTypeMeeting ||
          eventData['type'] == AppStrings.eventTypeConference ||
          eventData['type'] == AppStrings.eventTypeAppointment) {
        _locationController.text = eventData['location'] ?? '';
      }
      if (eventData['type'] == AppStrings.eventTypeExam) {
        _subjectController.text = eventData['subject'] ?? '';
      }
      if (eventData['type'] == AppStrings.eventTypeAppointment) {
        _withPersonYesNo = eventData['withPersonYesNo'] ?? false;
        _withPersonController.text = eventData['withPerson'] ?? '';
      }
      _updateDateTime();
    }
  }

  EventType _getEventTypeFromString(String typeString) {
    switch (typeString.toLowerCase()) {
      case AppStrings.eventTypeMeeting:
        return EventType.meeting;
      case AppStrings.eventTypeExam:
        return EventType.exam;
      case AppStrings.eventTypeConference:
        return EventType.conference;
      case AppStrings.eventTypeAppointment:
        return EventType.appointment;
      case AppStrings.eventTypeTask:
      default:
        return EventType.task;
    }
  }

  void _updateDateTime() {
    if (_selectedDate != null) {
      if (_selectedTime != null) {
        _selectedDateTime = Timestamp.fromDate(
          DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          ),
        );
      } else {
        _selectedDateTime = Timestamp.fromDate(_selectedDate!);
      }
    } else {
      _selectedDateTime = null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateTime();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
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
            timePickerTheme: const TimePickerThemeData(
              dayPeriodTextColor: Colors.white,
              dayPeriodTextStyle: TextStyle(fontWeight: FontWeight.bold),
              dayPeriodColor: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _updateDateTime();
      });
    }
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.addEventValidationTitle; // Usando constante
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.addEventValidationDescription; // Usando constante
    }
    return null;
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      if (widget.eventToEdit == null) {
        _eventViewModel
            .addEvent(
              _selectedEventType,
              _titleController.text,
              _descriptionController.text,
              _selectedPriority,
              _selectedDateTime,
              _hasNotification,
              _locationController.text,
              _subjectController.text,
              _withPersonController.text,
              _withPersonYesNo,
            )
            .then((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const CalendarScreen()),
                (Route<dynamic> route) => false,
              );
            })
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${AppStrings.addEventFailedToSave}$error'), // Usando constante
                  backgroundColor: Colors.red,
                ),
              );
            });
      } else {
        final String eventId = widget.eventToEdit!['id'] as String;
        _eventViewModel
            .updateEvent(
              eventId,
              _selectedEventType,
              _titleController.text,
              _descriptionController.text,
              _selectedPriority,
              _selectedDateTime,
              _hasNotification,
              _locationController.text,
              _subjectController.text,
              _withPersonYesNo,
              _withPersonController.text,
            )
            .then((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const CalendarScreen()),
                (Route<dynamic> route) => false,
              );
            })
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${AppStrings.addEventFailedToUpdate}$error'), // Usando constante
                  backgroundColor: Colors.red,
                ),
              );
            });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.addEventValidationDateTime), // Usando constante
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _subjectController.dispose();
    _withPersonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color headerColor = Colors.grey[800]!;
    const secondaryColor = AppColors.secondary;
    const onSecondaryColor = AppColors.onSecondary;
    const outlineColor = AppColors.outline;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const CalendarScreen()),
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
        title: ShiningTextAnimation(
          text: widget.eventToEdit == null ? AppStrings.addEventCreateTitle : AppStrings.addEventEditTitle, // Usando constantes
          style: TextStyles.urbanistBody1,
          shineColor: AppColors.textPrimary,
        ),
        backgroundColor: headerColor,
        foregroundColor: AppColors.outline,
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
              const SizedBox(height: 30.0),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: AppStrings.addEventFieldTitle, // Usando constante
                  labelStyle: TextStyles.plusJakartaSansSubtitle2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: secondaryColor, width: 1.5),
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
                validator: _validateTitle,
              ),
              const SizedBox(height: 18.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: AppStrings.addEventFieldDescription, // Usando constante
                  labelStyle: TextStyles.plusJakartaSansSubtitle2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: secondaryColor, width: 1.5),
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
                validator: _validateDescription,
              ),
              const SizedBox(height: 22.0),
              Text(
                AppStrings.addEventFieldPriority, // Usando constante
                style:  TextStyles.plusJakartaSansSubtitle2,
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildPriorityOption(
                    AppStrings.searchPriorityCritical, // Usando constante
                    Priority.critical,
                    const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                    onSecondaryColor,
                  ),
                  _buildPriorityOption(
                    AppStrings.searchPriorityHigh, // Usando constante
                    Priority.high,
                    secondaryColor.withOpacity(0.8),
                    onSecondaryColor,
                  ),
                  _buildPriorityOption(
                    AppStrings.searchPriorityMedium, // Usando constante
                    Priority.medium,
                    secondaryColor.withOpacity(0.8),
                    onSecondaryColor,
                  ),
                  _buildPriorityOption(
                    AppStrings.searchPriorityLow, // Usando constante
                    Priority.low,
                    secondaryColor.withOpacity(0.8),
                    onSecondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 22.0),
              Row(
                children: [
                  Switch(
                    value: _hasNotification,
                    activeColor: secondaryColor.withOpacity(0.7),
                    inactiveTrackColor: outlineColor.withOpacity(0.6),
                    inactiveThumbColor: Colors.grey[350],
                    onChanged: (bool value) {
                      setState(() {
                        _hasNotification = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      AppStrings.addEventFieldNotification, // Usando constante
                      style: TextStyles.plusJakartaSansSubtitle2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22.0),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: AppStrings.addEventFieldDate, // Usando constante
                           labelStyle: TextStyles.plusJakartaSansSubtitle2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: secondaryColor,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorText: _selectedDate == null
                              ? AppStrings.addEventValidationDate // Usando constante
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('yyyy/MM/dd').format(_selectedDate!)
                              : AppStrings.addEventSelectDate, // Usando constante
                          style: TextStyles.plusJakartaSansBody1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: AppStrings.addEventFieldTime, // Usando constante
                          labelStyle: TextStyles.plusJakartaSansSubtitle2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: secondaryColor,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorText: _selectedTime == null
                              ? AppStrings.addEventSelectTime // Usando constante
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          _selectedTime != null
                              ? DateFormat('hh:mm a').format(
                                  DateTime(
                                    2024,
                                    1,
                                    1,
                                    _selectedTime!.hour,
                                    _selectedTime!.minute,
                                  ),
                                )
                              : AppStrings.addEventDefaultTime, // Usando constante
                          style: TextStyles.plusJakartaSansBody1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22.0),
              DropdownButtonFormField<EventType>(
                value: _selectedEventType,
                onChanged: (EventType? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedEventType = newValue;
                    });
                  }
                },
                items: EventType.values
                    .where(
                      (type) => type != EventType.all,
                    )
                    .map<DropdownMenuItem<EventType>>((EventType value) {
                      return DropdownMenuItem<EventType>(
                        value: value,
                        child: Text(
                          value.toString().split('.').last.toUpperCase(),
                          style: TextStyles.plusJakartaSansBody1,
                        ),
                      );
                    })
                    .toList(),
                decoration: InputDecoration(
                  labelText: AppStrings.addEventFieldEventType, // Usando constante
                  labelStyle: TextStyles.plusJakartaSansSubtitle2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: secondaryColor, width: 1.5),
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
                style: TextStyles.plusJakartaSansBody1,
              ),
              const SizedBox(height: 22.0),
              if (_selectedEventType == EventType.meeting ||
                  _selectedEventType == EventType.conference ||
                  _selectedEventType == EventType.appointment)
                TextFormField(
                  controller: _locationController,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: AppStrings.addEventFieldLocation, // Usando constante
                    labelStyle: TextStyles.plusJakartaSansSubtitle2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: secondaryColor, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              if (_selectedEventType == EventType.exam)
                TextFormField(
                  controller: _subjectController,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: AppStrings.addEventFieldSubject, // Usando constante
                    labelStyle: TextStyles.plusJakartaSansSubtitle2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: secondaryColor, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              if (_selectedEventType == EventType.appointment)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Text(
                          AppStrings.addEventFieldWithPersonYesNo, // Usando constante
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Checkbox(
                          value: _withPersonYesNo,
                          onChanged: (bool? value) {
                            setState(() {
                              _withPersonYesNo = value ?? false;
                            });
                          },
                          activeColor: secondaryColor,
                          checkColor: onSecondaryColor,
                          side: BorderSide(color: outlineColor),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Visibility(
                        visible: _withPersonYesNo,
                        child: TextFormField(
                          controller: _withPersonController,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            labelText: AppStrings.addEventFieldWithPerson, // Usando constante
                            labelStyle: TextStyles.plusJakartaSansSubtitle2,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: onSecondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                    elevation: 2,
                  ),
                  child: Text(AppStrings.addEventSaveButton), // Usando constante
                ),
              ),
            ],
          ),
        ),
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
            _selectedPriority = priority;
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
}
