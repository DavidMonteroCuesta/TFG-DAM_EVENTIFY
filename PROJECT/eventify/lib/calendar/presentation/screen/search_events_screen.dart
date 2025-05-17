import 'package:eventify/calendar/domain/entities/events/appointment_event.dart';
import 'package:eventify/calendar/domain/entities/events/conference_event.dart';
import 'package:eventify/calendar/domain/entities/events/exam_event.dart';
import 'package:eventify/calendar/domain/entities/events/meeting_event.dart';
import 'package:eventify/calendar/domain/entities/events_type_enum.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/common/utils/priorities/priorities_enum.dart';
import 'package:eventify/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventSearchScreen extends StatefulWidget {
  const EventSearchScreen({super.key});
  static const String routeName = '/event-search';

  @override
  State<EventSearchScreen> createState() => _EventSearchScreenState();
}

class _EventSearchScreenState extends State<EventSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleSearchController = TextEditingController();
  final _descriptionSearchController = TextEditingController();
  final _dateSearchController = TextEditingController();
  EventType _selectedEventType = EventType.task;
  final _locationSearchController = TextEditingController();
  final _subjectSearchController = TextEditingController();
  final _withPersonSearchController = TextEditingController();
  bool _withPersonYesNoSearch = false;
  Priority _selectedPriority = Priority.medium;
  List<Event> _searchResults = [];
  late EventViewModel _eventViewModel;

  @override
  void initState() {
    super.initState();
    // Resolve EventViewModel using GetIt
    _eventViewModel = sl<EventViewModel>(); // Get the instance from the service locator
    _loadEvents();
    _titleSearchController.addListener(_searchEvents);
    _descriptionSearchController.addListener(_searchEvents);
    _dateSearchController.addListener(_searchEvents);
    _locationSearchController.addListener(_searchEvents);
    _subjectSearchController.addListener(_searchEvents);
    _withPersonSearchController.addListener(_searchEvents);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _loadEvents() async {
    try {
      await _eventViewModel.getEventsForCurrentUser();
      setState(() {
        _searchResults = _eventViewModel.events;
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to load events: ${e.toString()}')));
      }
    }
  }

  void _searchEvents() {
    setState(() {
      List<Event> allEvents = _eventViewModel.events;
      List<Event> results = allEvents;

      final title = _titleSearchController.text;
      final description = _descriptionSearchController.text;
      final date = _dateSearchController.text;

      if (title.isNotEmpty) {
        results = results
            .where((event) =>
                event.title.toLowerCase().contains(title.toLowerCase()))
            .toList();
      }
      if (description.isNotEmpty) {
        results = results
            .where((event) => event.description?.toLowerCase().contains(description.toLowerCase()) ?? false)
            .toList();
      }
      if (date.isNotEmpty) {
        DateTime? parsedDate = DateTime.tryParse(date);
        results = results.where((event) {
          if (event.date != null && parsedDate != null) {
            return DateFormat('yyyy-MM-dd').format(event.date!) ==
                DateFormat('yyyy-MM-dd').format(parsedDate);
          }
          return false;
        }).toList();
      }
      if (_selectedEventType != EventType.task) {
        results = results.where((event) {
          if (_selectedEventType == EventType.meeting &&
              event is MeetingEvent) {
            return true;
          } else if (_selectedEventType == EventType.exam &&
              event is ExamEvent) {
            return true;
          } else if (_selectedEventType == EventType.conference &&
              event is ConferenceEvent) {
            return true;
          } else if (_selectedEventType == EventType.appointment &&
              event is AppointmentEvent) {
            return true;
          }
          return false;
        }).toList();
      }
      if (_selectedPriority != Priority.medium) {
        results =
            results.where((event) => event.priority == _selectedPriority).toList();
      }
      if (_selectedEventType == EventType.meeting ||
          _selectedEventType == EventType.conference ||
          _selectedEventType == EventType.appointment) {
        if (_locationSearchController.text.isNotEmpty) {
          results = results.where((event) {
            if (event is MeetingEvent) {
              return event.location?.toLowerCase().contains(
                      _locationSearchController.text.toLowerCase()) ??
                  false;
            } else if (event is ConferenceEvent) {
              return event.location?.toLowerCase().contains(
                      _locationSearchController.text.toLowerCase()) ??
                  false;
            } else if (event is AppointmentEvent) {
              return event.location?.toLowerCase().contains(
                      _locationSearchController.text.toLowerCase()) ??
                  false;
            }
            return false;
          }).toList();
        }
      }
      if (_selectedEventType == EventType.exam) {
        if (_subjectSearchController.text.isNotEmpty) {
          results = results.where((event) {
            if (event is ExamEvent) {
              return event.subject?.toLowerCase().contains(
                      _subjectSearchController.text.toLowerCase()) ??
                  false;
            }
            return false;
          }).toList();
        }
      }
      if (_selectedEventType == EventType.appointment) {
        if (_withPersonYesNoSearch) {
          results = results.where((event) {
            if (event is AppointmentEvent) {
              return event.withPersonYesNo &&
                  (event.withPerson?.toLowerCase().contains(
                          _withPersonSearchController.text.toLowerCase()) ??
                      false);
            }
            return false;
          }).toList();
        }
      }
      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _titleSearchController.dispose();
    _descriptionSearchController.dispose();
    _dateSearchController.dispose();
    _locationSearchController.dispose();
    _subjectSearchController.dispose();
    _withPersonSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color headerColor = Colors.grey[800]!;
    const secondaryColor = Color(0xFF6750A4);
    const outlineColor = Color(0xFFE0E0E0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: ShiningTextAnimation(
          text: "Search Events",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
          shineColor: const Color(0xFFCBCBCB),
        ),
        backgroundColor: headerColor,
        foregroundColor: outlineColor,
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
                labelText: 'Event Title',
              ),
              _buildSearchField(
                controller: _descriptionSearchController,
                labelText: 'Description',
              ),
              _buildSearchField(
                controller: _dateSearchController,
                labelText: 'Date (YYYY-MM-DD)',
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
                items: EventType.values.map<DropdownMenuItem<EventType>>((
                  EventType value,
                ) {
                  return DropdownMenuItem<EventType>(
                    value: value,
                    child: Text(
                      value.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16.0,
                          color:
                              Color(0xFFCBCBCB)),
                    ),
                  );
                }).toList(),
                labelText: 'Event Type',
              ),
              _buildPrioritySelector(),
              if (_selectedEventType == EventType.meeting ||
                  _selectedEventType == EventType.conference ||
                  _selectedEventType == EventType.appointment)
                _buildSearchField(
                  controller: _locationSearchController,
                  labelText: 'Location',
                ),
              if (_selectedEventType == EventType.exam)
                _buildSearchField(
                  controller: _subjectSearchController,
                  labelText: 'Subject',
                ),
              if (_selectedEventType == EventType.appointment)
                _buildWithPersonField(),
              const SizedBox(height: 30.0),
              // Display search results
              if (_searchResults.isNotEmpty) ...[
                const SizedBox(height: 30.0),
                Text(
                  'Search Results (${_searchResults.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Color(0xFFCBCBCB),
                  ),
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _searchResults.map((event) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: outlineColor.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFCBCBCB),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Date: ${event.date != null ? DateFormat('EEE, MMM d,ypeł').format(event.date!) : 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.grey),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Time: ${event.time ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.grey),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Description: ${event.description ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: const Color(0xFFCBCBCB)),
                            ),
                            Text(
                              'Priority: ${event.priority.toString().split('.').last.toUpperCase()}',
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.yellow),
                            ),
                            if (event is MeetingEvent) ...[
                              const SizedBox(height: 4.0),
                              Text(
                                'Location: ${event.location ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    color: const Color(0xFFCBCBCB)),
                              ),
                            ],
                            if (event is ExamEvent) ...[
                              const SizedBox(height: 4.0),
                              Text(
                                'Subject: ${event.subject ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    color: const Color(0xFFCBCBCB)),
                              ),
                            ],
                            if (event is AppointmentEvent) ...[
                              const SizedBox(height: 4.0),
                              Text(
                                  'With Person: ${event.withPerson ?? 'N/A'}',
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      color: const Color(0xFFCBCBCB)),
                                  ),
                            ],
                          ],
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
        style: const TextStyle(
            fontSize: 16.0,
            color: const Color(0xFFCBCBCB)),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Color(0xFFE0E0E0), fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                const BorderSide(color: Color.fromRGBO(105, 240, 174, 1), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          filled: true,
          fillColor: const Color(0xFF1F1F1F),
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
          labelStyle: const TextStyle(
              color: Color(0xFFE0E0E0), fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                const BorderSide(color: Color(0xFF6750A4), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          filled: true,
          fillColor: const Color(0xFF1F1F1F),
        ),
        style: const TextStyle(
            fontSize: 16.0,
            color: const Color(0xFFCBCBCB)),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Priority',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                color: Color(0xFFCBCBCB)),
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: [
              _buildPriorityOption(
                  'CRITICAL',
                  Priority.critical,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F)),
              _buildPriorityOption(
                  'HIGH',
                  Priority.high,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F)),
              _buildPriorityOption(
                  'MEDIUM',
                  Priority.medium,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F)),
              _buildPriorityOption(
                  'LOW',
                  Priority.low,
                  const Color.fromRGBO(105, 240, 174, 1).withOpacity(0.8),
                  const Color(0xFF0F0F0F)),
            ],
          ),
        ],
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
            _searchEvents();
          }
        });
      },
      backgroundColor: backgroundColor.withOpacity(0.3),
      selectedColor: backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)),
      side: BorderSide(
          color: isSelected ? backgroundColor : Colors.grey[300]!),
      labelPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildWithPersonField() {
    const secondaryColor = Color.fromRGBO(105, 240, 174, 1);
    const outlineColor = Color(0xFFE0E0E0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "With Person (Yes/No):",
                style: TextStyle(
                    fontSize: 16.0, color:  Color(0xFFCBCBCB)),
              ),
              const SizedBox(width: 8.0),
              Checkbox(
                value: _withPersonYesNoSearch,
                onChanged: (bool? value) {
                  setState(() {
                    _withPersonYesNoSearch = value ?? false;
                    _searchEvents();
                  });
                },
                activeColor: secondaryColor.withOpacity(0.7),
                checkColor: const Color(0xFF0F0F0F),
                side: BorderSide(color: outlineColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Visibility(
              visible: _withPersonYesNoSearch,
              child: TextFormField(
                controller: _withPersonSearchController,
                style: const TextStyle(
                    fontSize: 16.0, color: const Color(0xFFCBCBCB)),
                decoration: InputDecoration(
                  labelText: 'With Person',
                  labelStyle: TextStyle(
                      color: outlineColor, fontWeight: FontWeight.w500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: secondaryColor, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

