import 'package:eventify/calendar/domain/entities/events/appointment_event.dart';
import 'package:eventify/calendar/domain/entities/events/conference_event.dart';
import 'package:eventify/calendar/domain/entities/events/exam_event.dart';
import 'package:eventify/calendar/domain/entities/events/meeting_event.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors
import 'package:eventify/calendar/presentation/screen/add_event/add_event_screen.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';

class DailiesEventScreen extends StatefulWidget {
  final DateTime selectedDate;

  const DailiesEventScreen({super.key, required this.selectedDate});

  @override
  State<DailiesEventScreen> createState() => _DailiesEventScreenState();
}

class _DailiesEventScreenState extends State<DailiesEventScreen> {
  late EventViewModel _eventViewModel;
  List<Map<String, dynamic>> _dailyEvents = [];

  @override
  void initState() {
    super.initState();
    _eventViewModel = sl<EventViewModel>();
    _loadDailyEvents();
  }

  DateTime _normalizeDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<void> _loadDailyEvents() async {
    try {
      await _eventViewModel.getEventsForCurrentUser();
      setState(() {
        _dailyEvents =
            _eventViewModel.events.where((eventData) {
              final Timestamp? eventTimestamp = eventData['dateTime'];
              if (eventTimestamp != null) {
                return _normalizeDate(eventTimestamp.toDate()) ==
                    _normalizeDate(widget.selectedDate);
              }
              return false;
            }).toList();
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppInternalConstants.dailiesFailedToLoadEvents}${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _onAddOrEditEvent({Map<String, dynamic>? eventData}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => AddEventScreen(
              eventToEdit: eventData,
            ),
      ),
    );

    if (result == true) {
      _loadDailyEvents();
      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  Future<void> _onDeleteEvent(Map<String, dynamic> eventData) async {
    final String eventId = eventData['id'] as String;
    final String eventTitle =
        eventData['title'] as String;

    final bool confirm =
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.dialogBackground, // Using AppColors
              title: Text(
                AppStrings.dailiesDeleteEventTitle(context),
                style: TextStyles.urbanistSubtitle1.copyWith(
                  color: AppColors.textPrimary, // Using AppColors
                ),
              ),
              content: Text(
                '${AppStrings.dailiesDeleteEventConfirmPrefix(context)}"$eventTitle"${AppStrings.dailiesDeleteEventConfirmSuffix(context)}',
                style: TextStyles.plusJakartaSansBody2.copyWith(
                  color: AppColors.textSecondary, // Using AppColors
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(false),
                  child: Text(
                    AppStrings.dailiesCancelButton(context),
                    style: TextStyles.plusJakartaSansSubtitle2.copyWith(
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.of(
                        context,
                      ).pop(true),
                  child: Text(
                    AppStrings.dailiesDeleteButton(context),
                    style: TextStyles.plusJakartaSansSubtitle2.copyWith(
                      color: AppColors.deleteButtonColor, // Using AppColors
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
        _loadDailyEvents();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppStrings.dailiesEventDeletedSuccessPrefix(context)}"$eventTitle"${AppStrings.dailiesEventDeletedSuccessSuffix(context)}'),
            ),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppInternalConstants.dailiesFailedToDeleteEvent}${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Color headerColor = Colors.grey[800]!; // Replaced by AppColors.headerBackground
    // const outlineColor = Color(0xFFE0E0E0); // Replaced by AppColors.outlineColorLight
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.outlineColorLight), // Using AppColors
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        title: ShiningTextAnimation(
          text:
              DateFormat('EEEE, dd MMMM', AppInternalConstants.dailiesLocaleEnUs)
                  .format(widget.selectedDate)
                  .toUpperCase(),
          style: TextStyles.urbanistBody1,
          shineColor: AppColors.shineColorLight, // Using AppColors
        ),
        backgroundColor: AppColors.headerBackground, // Using AppColors
        foregroundColor: AppColors.outlineColorLight, // Using AppColors
        elevation: 0,
        centerTitle: true,
        toolbarHeight: kToolbarHeight,
      ),
      body:
          _dailyEvents.isEmpty
              ? Center(
                child: Text(
                  AppStrings.dailiesNoEventsForThisDay(context),
                  style: TextStyles.urbanistSubtitle1.copyWith(
                    color: AppColors.textSecondary, // Using AppColors
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.dailiesEventsForPrefix(context)}${DateFormat('dd/MM/yyyy').format(widget.selectedDate)}${AppStrings.dailiesEventsCountSeparator(context)}${_dailyEvents.length}${AppStrings.dailiesEventsCountSuffix(context)}',
                      style: TextStyles.urbanistSubtitle1.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _dailyEvents.map((eventData) {
                            final String? currentUserId =
                                FirebaseAuth
                                    .instance
                                    .currentUser
                                    ?.uid;
                            if (currentUserId == null) {
                              return const SizedBox.shrink();
                            }

                            final Event event = EventFactory.createEvent(
                              _getEventTypeFromString(
                                eventData['type'] ?? AppInternalConstants.eventTypeTask,
                              ),
                              eventData,
                              currentUserId,
                            );

                            String eventTypeString = AppInternalConstants.dailiesNA;
                            if (event is MeetingEvent) {
                              eventTypeString = AppStrings.dailiesMeetingDisplay(context);
                            } else if (event is ExamEvent) {
                              eventTypeString = AppStrings.dailiesExamDisplay(context);
                            } else if (event is ConferenceEvent) {
                              eventTypeString = AppStrings.dailiesConferenceDisplay(context);
                            } else if (event is AppointmentEvent) {
                              eventTypeString = AppStrings.dailiesAppointmentDisplay(context);
                            } else {
                              eventTypeString = AppStrings.dailiesTaskDisplay(context);
                            }
                            String formattedDateTime =
                                event.dateTime != null
                                    ? DateFormat(
                                      'HH:mm',
                                    ).format(event.dateTime!.toDate())
                                    : AppInternalConstants.dailiesNA;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: SizedBox(
                                width: screenWidth * 0.9,
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBackground, // Using AppColors
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: AppColors.outlineColorLight.withOpacity(0.3), // Using AppColors
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              event.title,
                                              style: TextStyles
                                                  .plusJakartaSansBody1
                                                  .copyWith(fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: AppColors.editIconColor, // Using AppColors
                                                ),
                                                onPressed:
                                                    () => _onAddOrEditEvent(
                                                      eventData: eventData,
                                                    ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: AppColors.deleteIconColor, // Using AppColors
                                                ),
                                                onPressed:
                                                    () => _onDeleteEvent(
                                                      eventData,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '${AppStrings.dailiesTimePrefix(context)}$formattedDateTime',
                                        style: TextStyles.plusJakartaSansBody2,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '${AppStrings.dailiesTypePrefix(context)}$eventTypeString',
                                        style: TextStyles.plusJakartaSansBody2,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '${AppStrings.dailiesDescriptionPrefix(context)}${event.description ?? AppInternalConstants.dailiesNA}',
                                        style: TextStyles.plusJakartaSansBody2,
                                      ),
                                      Text(
                                        '${AppStrings.dailiesPriorityPrefix(context)}${event.priority.toString().split('.').last.toUpperCase()}',
                                        style: TextStyles.plusJakartaSansBody2
                                            .copyWith(color: AppColors.priorityTextColorDynamic), // Using AppColors
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddOrEditEvent(),
        backgroundColor: AppColors.primaryContainer,
        child: const Icon(Icons.add, color: AppColors.fabIconColor), // Using AppColors
      ),
    );
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
      default:
        return EventType.task;
    }
  }
}
