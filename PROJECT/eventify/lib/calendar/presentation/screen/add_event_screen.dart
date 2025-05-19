import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/calendar/presentation/screen/calendar_screen.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});
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
  EventType _selectedEventType = EventType.task;
  final _locationController = TextEditingController();
  final _subjectController = TextEditingController();
  final _withPersonController = TextEditingController();
  bool _withPersonYesNo = false;
  late final EventViewModel _eventViewModel;

  @override
  void initState() {
    super.initState();
    _eventViewModel = EventViewModel();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: AppColors.primaryContainer,
            hintColor: AppColors.secondary,
            colorScheme: ColorScheme.dark(primary: AppColors.primaryContainer)
                .copyWith(secondary: AppColors.secondary),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: AppColors.primaryContainer,
            hintColor: AppColors.secondary,
            colorScheme: ColorScheme.dark(primary: AppColors.primaryContainer)
                .copyWith(secondary: AppColors.secondary),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            timePickerTheme: const TimePickerThemeData(
              dayPeriodTextColor: Colors.white,
              dayPeriodTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
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
      });
    }
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the event title';
    }
    return null;
  }

  void _saveEvent() {
  if (_formKey.currentState!.validate()) {
     _eventViewModel.addEvent(
          _selectedEventType,
          _titleController.text,
          _descriptionController.text,
          _selectedPriority,
          _selectedDate,
          _selectedTime.toString(),
          _hasNotification,
          _locationController.text,
          _subjectController.text,
          _withPersonController.text,
          _withPersonYesNo,
          context,
    ).then((_) {
      Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const CalendarScreen(),
              ),
            );
    }).catchError((error) {
       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save event: $error'),
              backgroundColor: Colors.red,
            ),
          );
    });
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const CalendarScreen(),
              ),
            );
          },
        ),
        title:  ShiningTextAnimation(
          text: "CREATE NEW EVENT",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
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
                style: const TextStyle(fontSize: 16.0, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  labelStyle: TextStyle(color: outlineColor, fontWeight: FontWeight.w500),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                validator: _validateTitle,
              ),
              const SizedBox(height: 18.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: const TextStyle(fontSize: 16.0, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: outlineColor, fontWeight: FontWeight.w500),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
              const SizedBox(height: 22.0),
              Text('Priority',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: const Color.fromARGB(221, 255, 255, 255)
                          .withOpacity(0.8))),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildPriorityOption(
                      'CRITICAL',
                      Priority.critical,
                      const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                      onSecondaryColor),
                  _buildPriorityOption(
                      'HIGH',
                      Priority.high,
                      secondaryColor.withOpacity(0.8),
                      onSecondaryColor),
                  _buildPriorityOption(
                      'MEDIUM',
                      Priority.medium,
                      secondaryColor.withOpacity(0.8),
                      onSecondaryColor),
                  _buildPriorityOption(
                      'LOW',
                      Priority.low,
                      secondaryColor.withOpacity(0.8),
                      onSecondaryColor),
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
                    child: Text('Notification',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: const Color.fromARGB(221, 255, 255, 255)
                                .withOpacity(0.8))),
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
                          labelText: 'Date',
                          labelStyle: TextStyle(
                              color: outlineColor, fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                BorderSide(color: secondaryColor, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('EEE, MMM d,yyyy').format(_selectedDate!)
                              : 'Select Date',
                          style: const TextStyle(fontSize: 16.0),
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
                          labelText: 'Time',
                          labelStyle: TextStyle(color: outlineColor, fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                BorderSide(color: secondaryColor, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                        child: Text(
                          _selectedTime?.format(context) ?? 'Select Time',
                          style: const TextStyle(fontSize: 16.0),
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
                items: EventType.values.map<DropdownMenuItem<EventType>>((EventType value) {
                  return DropdownMenuItem<EventType>(
                    value: value,
                    child: Text(
                      value.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(fontSize: 16.0, color: AppColors.textPrimary),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Event Type',
                  labelStyle: TextStyle(color: outlineColor, fontWeight: FontWeight.w500),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                ),
                style: const TextStyle(fontSize: 16.0, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 22.0),
              if (_selectedEventType == EventType.meeting ||
                  _selectedEventType == EventType.conference ||
                  _selectedEventType == EventType.appointment)
                TextFormField(
                  controller: _locationController,
                  style: const TextStyle(fontSize: 16.0, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: TextStyle(color: outlineColor, fontWeight: FontWeight.w500),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              if (_selectedEventType == EventType.exam)
                TextFormField(
                  controller: _subjectController,
                  style: const TextStyle(fontSize: 16.0, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: TextStyle(color: outlineColor, fontWeight: FontWeight.w500),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              if (_selectedEventType == EventType.appointment)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        const Text(
                          "With Person (Yes/No):",
                          style: TextStyle(fontSize: 16.0, color: AppColors.textPrimary),
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
                          style: const TextStyle(fontSize: 16.0, color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'With Person',
                            labelStyle: TextStyle(color: outlineColor, fontWeight: FontWeight.w500),
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                        fontSize: 18.0, fontWeight: FontWeight.w600),
                    elevation: 2,
                  ),
                  child: const Text('Save Event'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityOption(String label, Priority priority,
      Color backgroundColor, Color textColor) {
    final isSelected = _selectedPriority == priority;
    return ChoiceChip(
      label: Text(label,
          style: TextStyle(
              color: isSelected ? textColor : Colors.black87.withOpacity(0.8))),
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)),
      side: BorderSide(
          color: isSelected ? backgroundColor : Colors.grey[300]!),
      labelPadding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
    );
  }
}