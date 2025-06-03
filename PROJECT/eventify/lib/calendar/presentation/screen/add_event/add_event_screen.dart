// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/calendar/presentation/screen/add_event/logic/add_event_logic.dart';
import 'package:eventify/calendar/presentation/screen/add_event/logic/validation_utils.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/date_time_pickers.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/event_description_field.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/event_title_field.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/event_type_dropdown.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/event_type_fields.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/notification_switch.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/priority_option_chip.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_routes.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  static String routeName = AppRoutes.addEvent;

  final Map<String, dynamic>? eventToEdit;

  const AddEventScreen({super.key, this.eventToEdit});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen>
    with AddEventLogic<AddEventScreen> {
  static const double _formPaddingH = 20.0;
  static const double _formPaddingTop = kToolbarHeight;
  static const double _formPaddingBottom = 0.0;
  static const double _headerHeight = kToolbarHeight;
  static const double _eventTitleSpacing = 30.0;
  static const double _eventDescriptionSpacing = 18.0;
  static const double _prioritySpacing = 22.0;
  static const double _priorityChipSpacing = 8.0;
  static const double _notificationSpacing = 22.0;
  static const double _dateTimeSpacing = 22.0;
  static const double _eventTypeSpacing = 22.0;
  static const double _eventTypeFieldsSpacing = 30.0;
  static const double _buttonPaddingV = 16.0;
  static const double _buttonBorderRadius = 12.0;
  static const double _buttonFontSize = 18.0;
  static const double _buttonElevation = 2.0;
  static const double _headerBlurSigma = 18.0;
  static const double _headerOpacity = 0.2;
  static const double _headerIconWidth = 48.0;
  static const double _priorityChipOpacity = 0.8;

  @override
  void initState() {
    super.initState();
    initAddEventLogic(widget.eventToEdit);
  }

  @override
  void dispose() {
    disposeAddEventLogic();
    super.dispose();
  }

  void _saveEvent() {
    // Guarda el evento nuevo o actualizado si el formulario es válido
    if (_isFormValid()) {
      if (widget.eventToEdit == null) {
        _addNewEvent();
      } else {
        _updateExistingEvent();
      }
    } else {
      _showValidationError();
    }
  }

  bool _isFormValid() {
    // Valida el formulario y que la fecha/hora esté seleccionada
    return formKey.currentState!.validate() && selectedDateTime != null;
  }

  void _addNewEvent() {
    // Llama al ViewModel para añadir un nuevo evento
    eventViewModel
        .addEvent(
          selectedEventType,
          titleController.text,
          descriptionController.text,
          selectedPriority,
          selectedDateTime,
          hasNotification,
          locationController.text,
          subjectController.text,
          withPersonController.text,
          withPersonYesNo,
        )
        .then((_) {
          if (mounted) Navigator.of(context).pop(true);
        })
        .catchError((error) {
          if (mounted) {
            _showSaveError(error);
          }
        });
  }

  void _updateExistingEvent() {
    // Llama al ViewModel para actualizar un evento existente
    final String eventId = widget.eventToEdit![AppFirestoreFields.id] as String;
    eventViewModel
        .updateEvent(
          eventId,
          selectedEventType,
          titleController.text,
          descriptionController.text,
          selectedPriority,
          selectedDateTime,
          hasNotification,
          locationController.text,
          subjectController.text,
          withPersonYesNo,
          withPersonController.text,
        )
        .then((_) {
          if (mounted) Navigator.of(context).pop(true);
        })
        .catchError((error) {
          if (mounted) {
            _showUpdateError(error);
          }
        });
  }

  void _showValidationError() {
    // Muestra un error si la validación falla
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(AppInternalConstants.addEventValidationDateTime),
        backgroundColor: AppColors.deleteButtonColor,
      ),
    );
  }

  void _showSaveError(dynamic error) {
    // Muestra un error si falla el guardado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppInternalConstants.addEventFailedToSave}$error'),
        backgroundColor: AppColors.deleteButtonColor,
      ),
    );
  }

  void _showUpdateError(dynamic error) {
    // Muestra un error si falla la actualización
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppInternalConstants.addEventFailedToUpdate}$error'),
        backgroundColor: AppColors.deleteButtonColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var secondaryColor = AppColors.secondaryDynamic;
    const onSecondaryColor = AppColors.onSecondary;
    const outlineColor = AppColors.outline;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                _formPaddingH,
                _formPaddingTop,
                _formPaddingH,
                _formPaddingBottom,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: _eventTitleSpacing),
                    EventTitleField(
                      controller: titleController,
                      labelText: AppStrings.addEventFieldTitle(context),
                      validator: validateTitle,
                      secondaryColor: secondaryColor,
                    ),
                    const SizedBox(height: _eventDescriptionSpacing),
                    EventDescriptionField(
                      controller: descriptionController,
                      labelText: AppStrings.addEventFieldDescription(context),
                      validator: validateDescription,
                      secondaryColor: secondaryColor,
                    ),
                    const SizedBox(height: _prioritySpacing),
                    Text(
                      AppStrings.addEventFieldPriority(context),
                      style: TextStyles.plusJakartaSansSubtitle2,
                    ),
                    const SizedBox(height: _priorityChipSpacing),
                    Wrap(
                      spacing: _priorityChipSpacing,
                      children: [
                        PriorityOptionChip(
                          label: AppStrings.searchPriorityCritical(context),
                          priority: Priority.critical,
                          selectedPriority: selectedPriority,
                          backgroundColor: AppColors.focusedBorderDynamic
                              .withOpacity(_priorityChipOpacity),
                          textColor: onSecondaryColor,
                          onSelected: (priority) {
                            setState(() {
                              selectedPriority = priority;
                            });
                          },
                        ),
                        PriorityOptionChip(
                          label: AppStrings.searchPriorityHigh(context),
                          priority: Priority.high,
                          selectedPriority: selectedPriority,
                          backgroundColor: AppColors.focusedBorderDynamic
                              .withOpacity(_priorityChipOpacity),
                          textColor: onSecondaryColor,
                          onSelected: (priority) {
                            setState(() {
                              selectedPriority = priority;
                            });
                          },
                        ),
                        PriorityOptionChip(
                          label: AppStrings.searchPriorityMedium(context),
                          priority: Priority.medium,
                          selectedPriority: selectedPriority,
                          backgroundColor: AppColors.focusedBorderDynamic
                              .withOpacity(_priorityChipOpacity),
                          textColor: onSecondaryColor,
                          onSelected: (priority) {
                            setState(() {
                              selectedPriority = priority;
                            });
                          },
                        ),
                        PriorityOptionChip(
                          label: AppStrings.searchPriorityLow(context),
                          priority: Priority.low,
                          selectedPriority: selectedPriority,
                          backgroundColor: AppColors.focusedBorderDynamic
                              .withOpacity(_priorityChipOpacity),
                          textColor: onSecondaryColor,
                          onSelected: (priority) {
                            setState(() {
                              selectedPriority = priority;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: _notificationSpacing),
                    NotificationSwitch(
                      value: hasNotification,
                      onChanged: (bool value) {
                        setState(() {
                          hasNotification = value;
                        });
                      },
                      label: AppStrings.addEventFieldNotification(context),
                      activeColor: secondaryColor,
                    ),
                    const SizedBox(height: _dateTimeSpacing),
                    DateTimePickers(
                      selectedDate: selectedDate,
                      selectedTime: selectedTime,
                      onSelectDate: () => selectDate(context),
                      onSelectTime: () => selectTime(context),
                      dateLabel: AppStrings.addEventFieldDate(context),
                      timeLabel: AppStrings.addEventFieldTime(context),
                      dateErrorText:
                          selectedDate == null
                              ? AppInternalConstants.addEventValidationDate
                              : null,
                      timeErrorText:
                          selectedTime == null
                              ? AppStrings.addEventSelectTime(context)
                              : null,
                      secondaryColor: secondaryColor,
                    ),
                    const SizedBox(height: _eventTypeSpacing),
                    EventTypeDropdown(
                      selectedEventType: selectedEventType,
                      onChanged: (EventType? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedEventType = newValue;
                          });
                        }
                      },
                      labelText: AppStrings.addEventFieldEventType(context),
                      secondaryColor: secondaryColor,
                    ),
                    const SizedBox(height: _eventTypeFieldsSpacing),
                    EventTypeFields(
                      selectedEventType: selectedEventType,
                      locationController: locationController,
                      subjectController: subjectController,
                      withPersonController: withPersonController,
                      withPersonYesNo: withPersonYesNo,
                      onWithPersonChanged: (bool? value) {
                        setState(() {
                          withPersonYesNo = value ?? false;
                        });
                      },
                      secondaryColor: secondaryColor,
                      onSecondaryColor: onSecondaryColor,
                      outlineColor: outlineColor,
                      locationLabel: AppStrings.addEventFieldLocation(context),
                      subjectLabel: AppStrings.addEventFieldSubject(context),
                      withPersonYesNoLabel:
                          AppStrings.addEventFieldWithPersonYesNo(context),
                      withPersonLabel: AppStrings.addEventFieldWithPerson(
                        context,
                      ),
                    ),
                    const SizedBox(height: _eventTitleSpacing),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          foregroundColor: onSecondaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: _buttonPaddingV,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              _buttonBorderRadius,
                            ),
                          ),
                          textStyle: const TextStyle(
                            fontSize: _buttonFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: _buttonElevation,
                        ),
                        child: Text(AppStrings.addEventSaveButton(context)),
                      ),
                    ),
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
                          if (mounted) {
                            Navigator.of(context).pop(false);
                          }
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: ShiningTextAnimation(
                            text:
                                widget.eventToEdit == null
                                    ? AppStrings.addEventCreateTitle(context)
                                    : AppStrings.addEventEditTitle(context),
                            style: TextStyles.urbanistBody1,
                            shineColor: AppColors.textPrimary,
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
      ),
    );
  }
}
