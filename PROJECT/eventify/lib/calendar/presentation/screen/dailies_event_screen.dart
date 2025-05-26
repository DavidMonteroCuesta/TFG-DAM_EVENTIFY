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
import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/calendar/presentation/screen/add_event_screen.dart';
import 'package:eventify/calendar/domain/entities/event_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventify/common/constants/app_strings.dart'; // Importación de la interfaz de constantes
import 'package:eventify/common/constants/app_internal_constants.dart'; // Import AppInternalConstants

class DailiesEventScreen extends StatefulWidget {
  final DateTime selectedDate;

  const DailiesEventScreen({super.key, required this.selectedDate});

  @override
  State<DailiesEventScreen> createState() => _DailiesEventScreenState();
}

class _DailiesEventScreenState extends State<DailiesEventScreen> {
  late EventViewModel _eventViewModel;
  // Now stores List<Map<String, dynamic>>
  List<Map<String, dynamic>> _dailyEvents = [];

  @override
  void initState() {
    super.initState();
    _eventViewModel = sl<EventViewModel>();
    _loadDailyEvents();
  }

  // Helper to normalize DateTime to date components only (year, month, day)
  DateTime _normalizeDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  // Loads events for the currently selected day from the EventViewModel
  Future<void> _loadDailyEvents() async {
    try {
      // Get all user events as List<Map<String, dynamic>>
      await _eventViewModel.getEventsForCurrentUser();
      setState(() {
        // Filter events to show only those for the selected date
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

  // Handles navigation to AddEventScreen for adding new events or editing existing ones.
  // If 'eventData' is provided, it's an edit operation; otherwise, it's an add operation.
  Future<void> _onAddOrEditEvent({Map<String, dynamic>? eventData}) async {
    // Navigate to AddEventScreen, passing event data to edit if applicable.
    // 'result' will be true if an event was successfully saved/updated.
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => AddEventScreen(
              eventToEdit: eventData,
            ), // Pass event data for editing
      ),
    );

    if (result == true) {
      // If an event was added or edited, reload daily events to update the list.
      _loadDailyEvents();
      // Indicate that data might have changed, so CalendarScreen should refresh
      if (context.mounted) {
        Navigator.of(context).pop(true); // Return true to signal a change
      }
    }
  }

  // Handles event deletion.
  Future<void> _onDeleteEvent(Map<String, dynamic> eventData) async {
    final String eventId = eventData['id'] as String; // Get ID from the map
    final String eventTitle =
        eventData['title'] as String; // Get title from the map

    // Show a confirmation dialog before deleting the event.
    final bool confirm =
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                // PASAR CONTEXTO AQUÍ
                AppStrings.dailiesDeleteEventTitle(context),
                style: TextStyles.urbanistSubtitle1.copyWith(
                  color: Colors.white,
                ),
              ),
              content: Text(
                // PASAR CONTEXTO AQUÍ
                '${AppStrings.dailiesDeleteEventConfirmPrefix(context)}"$eventTitle"${AppStrings.dailiesDeleteEventConfirmSuffix(context)}',
                style: TextStyles.plusJakartaSansBody2.copyWith(
                  color: Colors.grey,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(false), // User canceled
                  child: Text(
                    // PASAR CONTEXTO AQUÍ
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
                      ).pop(true), // User confirmed deletion
                  child: Text(
                    // PASAR CONTEXTO AQUÍ
                    AppStrings.dailiesDeleteButton(context),
                    style: TextStyles.plusJakartaSansSubtitle2.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if the dialog is dismissed

    if (confirm) {
      try {
        // Call the deleteEvent method of EventViewModel
        await _eventViewModel.deleteEvent(eventId);
        _loadDailyEvents(); // Reload events after successful deletion
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // PASAR CONTEXTO AQUÍ
              content: Text('${AppStrings.dailiesEventDeletedSuccessPrefix(context)}"$eventTitle"${AppStrings.dailiesEventDeletedSuccessSuffix(context)}'),
            ),
          );
          // Indicate that data has changed, so CalendarScreen should refresh
          Navigator.of(context).pop(true); // Return true to signal a change
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
    final Color headerColor = Colors.grey[800]!;
    const outlineColor = Color(0xFFE0E0E0);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen (CalendarScreen)
            Navigator.of(context).pop(false); // Return false if no change
          },
        ),
        title: ShiningTextAnimation(
          text:
              DateFormat('EEEE, dd MMMM', AppInternalConstants.dailiesLocaleEnUs) // Using constant
                  .format(widget.selectedDate)
                  .toUpperCase(), // Display selected date in English
          style: TextStyles.urbanistBody1,
          shineColor: const Color(0xFFCBCBCB),
        ),
        backgroundColor: headerColor,
        foregroundColor: outlineColor,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: kToolbarHeight,
      ),
      body:
          _dailyEvents.isEmpty
              ? Center(
                child: Text(
                  // PASAR CONTEXTO AQUÍ
                  AppStrings.dailiesNoEventsForThisDay(context),
                  style: TextStyles.urbanistSubtitle1.copyWith(
                    color: Colors.grey,
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // PASAR CONTEXTO AQUÍ
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
                            // Create an Event object from the map for type-specific access
                            final String? currentUserId =
                                FirebaseAuth
                                    .instance
                                    .currentUser
                                    ?.uid; // Get the actual authenticated user's UID
                            if (currentUserId == null) {
                              // Handle the case where the user is not authenticated (this shouldn't happen here if login worked)
                              return const SizedBox.shrink(); // Or show an error message
                            }

                            final Event event = EventFactory.createEvent(
                              _getEventTypeFromString(
                                eventData['type'] ?? AppInternalConstants.eventTypeTask, // Using constant
                              ),
                              eventData, // Pass the map directly
                              currentUserId, // Pass userId
                            );

                            String eventTypeString = AppInternalConstants.dailiesNA; // Using constant
                            // Determine the event type string based on the runtime type of the event object
                            if (event is MeetingEvent) {
                              eventTypeString = AppStrings.dailiesMeetingDisplay(context); // PASAR CONTEXTO AQUÍ
                            } else if (event is ExamEvent) {
                              eventTypeString = AppStrings.dailiesExamDisplay(context); // PASAR CONTEXTO AQUÍ
                            } else if (event is ConferenceEvent) {
                              eventTypeString = AppStrings.dailiesConferenceDisplay(context); // PASAR CONTEXTO AQUÍ
                            } else if (event is AppointmentEvent) {
                              eventTypeString = AppStrings.dailiesAppointmentDisplay(context); // PASAR CONTEXTO AQUÍ
                            } else {
                              eventTypeString = AppStrings.dailiesTaskDisplay(context); // PASAR CONTEXTO AQUÍ
                            }
                            // Format event time
                            String formattedDateTime =
                                event.dateTime != null
                                    ? DateFormat(
                                      'HH:mm',
                                    ).format(event.dateTime!.toDate())
                                    : AppInternalConstants.dailiesNA; // Using constant

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
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
                                              // Edit button
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.blueAccent,
                                                ),
                                                onPressed:
                                                    () => _onAddOrEditEvent(
                                                      eventData: eventData,
                                                    ), // Pass eventData for editing
                                              ),
                                              // Delete button
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed:
                                                    () => _onDeleteEvent(
                                                      eventData,
                                                    ), // Pass eventData for deleting
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        // PASAR CONTEXTO AQUÍ
                                        '${AppStrings.dailiesTimePrefix(context)}$formattedDateTime',
                                        style: TextStyles.plusJakartaSansBody2,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        // PASAR CONTEXTO AQUÍ
                                        '${AppStrings.dailiesTypePrefix(context)}$eventTypeString',
                                        style: TextStyles.plusJakartaSansBody2,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        // PASAR CONTEXTO AQUÍ
                                        '${AppStrings.dailiesDescriptionPrefix(context)}${event.description ?? AppInternalConstants.dailiesNA}', // Using constant
                                        style: TextStyles.plusJakartaSansBody2,
                                      ),
                                      Text(
                                        // PASAR CONTEXTO AQUÍ
                                        '${AppStrings.dailiesPriorityPrefix(context)}${event.priority.toString().split('.').last.toUpperCase()}',
                                        style: TextStyles.plusJakartaSansBody2
                                            .copyWith(color: Colors.yellow),
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
        onPressed: () => _onAddOrEditEvent(), // Call add function
        backgroundColor: AppColors.primaryContainer,
        child: const Icon(Icons.add, color: Colors.white),
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