import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/widgets/calendar/widgets/upcoming_event_card.dart'; // Asegúrate de la ruta correcta

class MonthlyCalendar extends StatefulWidget {
  const MonthlyCalendar({super.key});

  @override
  State<MonthlyCalendar> createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  late DateTime _focusedDay;
  late DateTime _firstDayOfMonth;
  late DateTime _lastDayOfMonth;
  late List<DateTime> _daysInMonth;

  final upcomingEvent = const { // Ejemplo de evento para mostrar
    'title': 'Evento del mes',
    'type': 'Recordatorio',
    'date': '2025-04-18 15:00:00',
    'priority': 'Normal',
    'description': 'Este es un evento de ejemplo en el calendario mensual.',
  };

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _updateCalendarDays();
  }

  void _updateCalendarDays() {
    _firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    _lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _daysInMonth = List.generate(
      _lastDayOfMonth.day,
      (i) => DateTime(_focusedDay.year, _focusedDay.month, i + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(_focusedDay),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek
                .map((day) => Text(
                      day,
                      style: const TextStyle(color: Colors.white70),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          Expanded( // El GridView ocupa el espacio necesario para los días
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _daysInMonth.length + _firstDayOfMonth.weekday - 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                if (index < _firstDayOfMonth.weekday - 1) {
                  return const SizedBox();
                }
                final day = _daysInMonth[index - (_firstDayOfMonth.weekday - 1)];
                final isToday = day.year == DateTime.now().year &&
                    day.month == DateTime.now().month &&
                    day.day == DateTime.now().day;

                return Container(
                  decoration: BoxDecoration(
                    color: isToday ? Colors.blueAccent : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          UpcomingEventCard(
            title: upcomingEvent['title'] as String,
            type: upcomingEvent['type'] as String,
            date: DateTime.parse(upcomingEvent['date'] as String),
            priority: upcomingEvent['priority'] as String,
            description: upcomingEvent['description'] as String,
          ),
        ],
      ),
    );
  }
}