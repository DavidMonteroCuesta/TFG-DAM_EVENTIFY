import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/calendar/domain/entities/event.dart';

// Import the DailiesEventScreen
import 'package:eventify/calendar/presentation/screen/dailies_event_screen.dart';


class MonthlyCalendar extends StatefulWidget {
  final DateTime initialFocusedDay;

  const MonthlyCalendar({super.key, required this.initialFocusedDay});

  @override
  State<MonthlyCalendar> createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  late DateTime _focusedDay;
  late DateTime _firstDayOfMonth;
  late DateTime _lastDayOfMonth;
  late List<DateTime> _daysInMonth;
  late EventViewModel _eventViewModel;
  List<Event> _eventsForCurrentMonth = [];
  Set<DateTime> _datesWithEvents = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay;
    _eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    _loadEventsForMonth();
  }

  @override
  void didUpdateWidget(covariant MonthlyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFocusedDay.year != oldWidget.initialFocusedDay.year ||
        widget.initialFocusedDay.month != oldWidget.initialFocusedDay.month ||
        widget.initialFocusedDay.day != oldWidget.initialFocusedDay.day) {
      setState(() {
        _focusedDay = widget.initialFocusedDay;
        _loadEventsForMonth();
      });
    }
  }

  void _updateCalendarDays() {
    _firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    _lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _daysInMonth = List.generate(
      _lastDayOfMonth.day,
      (i) => DateTime(_focusedDay.year, _focusedDay.month, i + 1),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
      _loadEventsForMonth();
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
      _loadEventsForMonth();
    });
  }

  Future<void> _loadEventsForMonth() async {
    _updateCalendarDays();
    try {
      final events = await _eventViewModel.getEventsForCurrentUserAndMonth(
        _focusedDay.year,
        _focusedDay.month,
      );
      setState(() {
        _eventsForCurrentMonth = events;
        _datesWithEvents = events
            .where((event) => event.dateTime != null)
            .map((event) => DateTime(
                event.dateTime!.toDate().year,
                event.dateTime!.toDate().month,
                event.dateTime!.toDate().day))
            .toSet();
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error loading events for month: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']; // Days of the week in English

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: _goToPreviousMonth,
              ),
              Text(
                DateFormat('MMMM', 'en_US').format(_focusedDay), // Month format in English
                style: TextStyles.urbanistH6,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: _goToNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek
                .map((day) => Text(
                      day,
                      style: const TextStyle(color: Colors.orangeAccent),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _daysInMonth.length + (_firstDayOfMonth.weekday == 7 ? 6 : _firstDayOfMonth.weekday - 1),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                final int weekdayOffset = _firstDayOfMonth.weekday == 7 ? 6 : _firstDayOfMonth.weekday - 1;

                if (index < weekdayOffset) {
                  return const SizedBox();
                }
                final day = _daysInMonth[index - weekdayOffset];
                final isToday = day.year == DateTime.now().year &&
                    day.month == DateTime.now().month &&
                    day.day == DateTime.now().day;
                final hasEvent = _datesWithEvents.contains(day);

                // *** Point 2: Access the new screen by clicking on a day ***
                return GestureDetector( // Wrap the Container with GestureDetector
                  onTap: () {
                    // Navigate to DailiesEventScreen passing the date of the clicked day
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailiesEventScreen(selectedDate: day),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday
                          ? Colors.grey[300]!.withOpacity(0.2)
                          : null,
                      shape: isToday ? BoxShape.circle : BoxShape.rectangle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isToday || hasEvent
                              ? Colors.orangeAccent
                              : Colors.white,
                          fontWeight: isToday || hasEvent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_eventsForCurrentMonth.isNotEmpty)
            Text(
              'Events for this month: ${_eventsForCurrentMonth.length}', // English
              style: TextStyles.plusJakartaSansBody1,
            )
          else
            Text(
              'No events for this month.', // English
              style: TextStyles.plusJakartaSansBody1,
            ),
        ],
      ),
    );
  }
}