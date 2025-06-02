import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/di/service_locator.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'event_type_utils.dart';
import 'date_time_utils.dart';

mixin AddEventLogic<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Priority selectedPriority = Priority.medium;
  bool hasNotification = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Timestamp? selectedDateTime;
  EventType selectedEventType = EventType.task;
  final locationController = TextEditingController();
  final subjectController = TextEditingController();
  final withPersonController = TextEditingController();
  bool withPersonYesNo = false;
  late final EventViewModel eventViewModel;

  void initAddEventLogic(Map<String, dynamic>? eventToEdit) {
    eventViewModel = sl<EventViewModel>();
    selectedDate = DateTime.now();
    selectedTime = const TimeOfDay(hour: 1, minute: 0);
    selectedDateTime = calculateSelectedDateTime(selectedDate, selectedTime);
    if (eventToEdit != null) {
      final eventData = eventToEdit;
      titleController.text = eventData['title'] ?? '';
      descriptionController.text = eventData['description'] ?? '';
      selectedPriority = PriorityConverter.stringToPriority(
        eventData['priority'],
      );
      hasNotification = eventData['hasNotification'] ?? false;
      final Timestamp? eventTimestamp = eventData['dateTime'];
      if (eventTimestamp != null) {
        selectedDate = eventTimestamp.toDate();
        selectedTime = TimeOfDay.fromDateTime(eventTimestamp.toDate());
      }
      selectedEventType = getEventTypeFromString(eventData['type']);
      if (eventData['type'] == AppInternalConstants.eventTypeMeeting ||
          eventData['type'] == AppInternalConstants.eventTypeConference ||
          eventData['type'] == AppInternalConstants.eventTypeAppointment) {
        locationController.text = eventData['location'] ?? '';
      }
      if (eventData['type'] == AppInternalConstants.eventTypeExam) {
        subjectController.text = eventData['subject'] ?? '';
      }
      if (eventData['type'] == AppInternalConstants.eventTypeAppointment) {
        withPersonYesNo = eventData['withPersonYesNo'] ?? false;
        withPersonController.text = eventData['withPerson'] ?? '';
      }
      selectedDateTime = calculateSelectedDateTime(selectedDate, selectedTime);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.secondaryDynamic,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.inputFillColor,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondaryDynamic,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDateTime = calculateSelectedDateTime(
          selectedDate,
          selectedTime,
        );
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.secondaryDynamic,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.inputFillColor,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondaryDynamic,
              ),
            ),
          ),
          child: child!,
        );
      },
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        selectedDateTime = calculateSelectedDateTime(
          selectedDate,
          selectedTime,
        );
      });
    }
  }

  void disposeAddEventLogic() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    subjectController.dispose();
    withPersonController.dispose();
  }
}
