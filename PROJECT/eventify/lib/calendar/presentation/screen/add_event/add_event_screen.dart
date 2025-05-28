import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/calendar/domain/enums/priorities_enum.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/priority_option_chip.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/notification_switch.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/date_time_pickers.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/event_type_fields.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/event_title_field.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/event_description_field.dart';
import 'package:eventify/calendar/presentation/screen/add_event/widgets/event_type_dropdown.dart';
import 'package:eventify/calendar/presentation/screen/add_event/logic/add_event_logic.dart';
import 'package:eventify/calendar/presentation/screen/add_event/logic/validation_utils.dart';

class AddEventScreen extends StatefulWidget {
  final Map<String, dynamic>? eventToEdit;

  const AddEventScreen({super.key, this.eventToEdit});
  static const String routeName = '/add-event';

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen>
    with AddEventLogic<AddEventScreen> {
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
    if (formKey.currentState!.validate() && selectedDateTime != null) {
      if (widget.eventToEdit == null) {
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${AppInternalConstants.addEventFailedToSave}$error',
                    ),
                    backgroundColor: AppColors.deleteButtonColor,
                  ),
                );
              }
            });
      } else {
        final String eventId = widget.eventToEdit!['id'] as String;
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${AppInternalConstants.addEventFailedToUpdate}$error',
                    ),
                    backgroundColor: AppColors.deleteButtonColor,
                  ),
                );
              }
            });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(AppInternalConstants.addEventValidationDateTime),
          backgroundColor: AppColors.deleteButtonColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var secondaryColor = AppColors.secondaryDynamic;
    const onSecondaryColor = AppColors.onSecondary;
    const outlineColor = AppColors.outline;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
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
          title: ShiningTextAnimation(
            text: widget.eventToEdit == null
                ? AppStrings.addEventCreateTitle(context)
                : AppStrings.addEventEditTitle(context),
            style: TextStyles.urbanistBody1,
            shineColor: AppColors.textPrimary,
          ),
          // ignore: deprecated_member_use
          backgroundColor: AppColors.headerBackground.withOpacity(0.8),
          foregroundColor: AppColors.outline,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: kToolbarHeight,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                EventTitleField(
                  controller: titleController,
                  labelText: AppStrings.addEventFieldTitle(context),
                  validator: validateTitle,
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 18.0),
                EventDescriptionField(
                  controller: descriptionController,
                  labelText: AppStrings.addEventFieldDescription(context),
                  validator: validateDescription,
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 22.0),
                Text(
                  AppStrings.addEventFieldPriority(context),
                  style: TextStyles.plusJakartaSansSubtitle2,
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  children: [
                    PriorityOptionChip(
                      label: AppStrings.searchPriorityCritical(context),
                      priority: Priority.critical,
                      selectedPriority: selectedPriority,
                      // ignore: deprecated_member_use
                      backgroundColor: AppColors.focusedBorderDynamic
                          .withOpacity(0.8),
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
                      // ignore: deprecated_member_use
                      backgroundColor: AppColors.focusedBorderDynamic
                          .withOpacity(0.8),
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
                      // ignore: deprecated_member_use
                      backgroundColor: AppColors.focusedBorderDynamic
                          .withOpacity(0.8),
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
                      // ignore: deprecated_member_use
                      backgroundColor: AppColors.focusedBorderDynamic
                          .withOpacity(0.8),
                      textColor: onSecondaryColor,
                      onSelected: (priority) {
                        setState(() {
                          selectedPriority = priority;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 22.0),
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
                const SizedBox(height: 22.0),
                DateTimePickers(
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  onSelectDate: () => selectDate(context),
                  onSelectTime: () => selectTime(context),
                  dateLabel: AppStrings.addEventFieldDate(context),
                  timeLabel: AppStrings.addEventFieldTime(context),
                  dateErrorText: selectedDate == null
                      ? AppInternalConstants.addEventValidationDate
                      : null,
                  timeErrorText: selectedTime == null
                      ? AppStrings.addEventSelectTime(context)
                      : null,
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 22.0),
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
                const SizedBox(height: 22.0),
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
                  withPersonYesNoLabel: AppStrings.addEventFieldWithPersonYesNo(
                    context,
                  ),
                  withPersonLabel: AppStrings.addEventFieldWithPerson(context),
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
                    child: Text(AppStrings.addEventSaveButton(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
