import 'package:eventify/calendar/presentation/screen/widgets/upcoming_event_card.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyCalendar extends StatefulWidget {
  final DateTime initialFocusedDay; // Nuevo parámetro

  const MonthlyCalendar({super.key, required this.initialFocusedDay}); // Constructor actualizado

  @override
  State<MonthlyCalendar> createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  late DateTime _focusedDay;
  late DateTime _firstDayOfMonth;
  late DateTime _lastDayOfMonth;
  late List<DateTime> _daysInMonth;

  // TODO: Este UpcomingEventCard es un placeholder. Deberías cargar los eventos del mes actual.
  final upcomingEvent = const {
    'title': 'Evento del mes',
    'type': 'Recordatorio',
    'date': '2025-04-18 15:00:00',
    'priority': 'Normal',
    'description': 'Este es un evento de ejemplo en el calendario mensual.',
  };

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay; // Usa el parámetro inicial
    _updateCalendarDays();
  }

  @override
  void didUpdateWidget(covariant MonthlyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Solo actualiza si la fecha inicial ha cambiado para evitar reconstrucciones innecesarias
    if (widget.initialFocusedDay.year != oldWidget.initialFocusedDay.year ||
        widget.initialFocusedDay.month != oldWidget.initialFocusedDay.month) {
      setState(() {
        _focusedDay = widget.initialFocusedDay;
        _updateCalendarDays();
      });
    }
  }

  void _updateCalendarDays() {
    _firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    // El día 0 del mes siguiente es el último día del mes actual
    _lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _daysInMonth = List.generate(
      _lastDayOfMonth.day,
      (i) => DateTime(_focusedDay.year, _focusedDay.month, i + 1),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
      _updateCalendarDays();
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
      _updateCalendarDays();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Para que la semana empiece en lunes (1 = lunes, ..., 7 = domingo)
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
                DateFormat('MMMM yyyy', 'es_ES').format(_focusedDay), // Formato completo con localización
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
              // Calcula el offset para que el primer día del mes se alinee correctamente con el lunes
              itemCount: _daysInMonth.length + (_firstDayOfMonth.weekday == 7 ? 6 : _firstDayOfMonth.weekday - 1),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                // Ajuste para que el primer día de la semana sea lunes (weekday de DateTime es 1=lunes, 7=domingo)
                // Si el primer día del mes es domingo (7), necesitamos 6 espacios en blanco antes.
                // Si es lunes (1), necesitamos 0 espacios en blanco.
                final int weekdayOffset = _firstDayOfMonth.weekday == 7 ? 6 : _firstDayOfMonth.weekday - 1;

                if (index < weekdayOffset) {
                  return const SizedBox();
                }
                final day = _daysInMonth[index - weekdayOffset];
                final isToday = day.year == DateTime.now().year &&
                    day.month == DateTime.now().month &&
                    day.day == DateTime.now().day;

                return Container(
                  decoration: BoxDecoration(
                    color: isToday ? Colors.orangeAccent : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // El UpcomingEventCard aquí es un placeholder.
          // Deberías usar el EventViewModel para cargar eventos del mes actual.
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
