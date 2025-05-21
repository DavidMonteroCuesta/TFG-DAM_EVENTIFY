import 'package:eventify/calendar/presentation/screen/widgets/upcoming_event_card.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Importa Provider
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart'; // Importa el ViewModel
import 'package:eventify/calendar/domain/entities/event.dart'; // Importa la entidad Event
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Timestamp para toDate()

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
  late EventViewModel _eventViewModel; // Instancia del ViewModel
  List<Event> _eventsForCurrentMonth = []; // Lista para eventos del mes actual
  Set<DateTime> _datesWithEvents = {}; // Set para fechas con eventos

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay;
    _eventViewModel = Provider.of<EventViewModel>(context, listen: false); // Inicializa el ViewModel
    _loadEventsForMonth(); // Carga inicial de eventos
  }

  @override
  void didUpdateWidget(covariant MonthlyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFocusedDay.year != oldWidget.initialFocusedDay.year ||
        widget.initialFocusedDay.month != oldWidget.initialFocusedDay.month) {
      setState(() {
        _focusedDay = widget.initialFocusedDay;
        _loadEventsForMonth(); // Recarga cuando la fecha inicial cambia
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
      _loadEventsForMonth(); // Recarga al cambiar de mes
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
      _loadEventsForMonth(); // Recarga al cambiar de mes
    });
  }

  Future<void> _loadEventsForMonth() async {
    _updateCalendarDays(); // Asegura que los días del calendario estén actualizados
    try {
      // Ahora getEventsForCurrentUserAndMonth devuelve List<Event>
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
                DateFormat('MMMM', 'es_ES').format(_focusedDay), // Formato completo con localización
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
                final hasEvent = _datesWithEvents.contains(day); // Comprueba si el día tiene eventos

                return Container(
                  decoration: BoxDecoration(
                    color: isToday
                        ? Colors.orangeAccent // Color para el día actual
                        : null, // Sin color de fondo si no es hoy
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isToday
                            ? Colors.white // Texto blanco para el día actual
                            : hasEvent
                                ? Colors.orangeAccent  // Color verde para días con eventos
                                : Colors.white, // Texto blanco por defecto
                        fontWeight: isToday || hasEvent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Muestra un mensaje basado en si hay eventos o no
          if (_eventsForCurrentMonth.isNotEmpty)
            Text(
              'Eventos para este mes: ${_eventsForCurrentMonth.length}',
              style: TextStyles.plusJakartaSansBody1,
            )
          else
            Text(
              'No hay eventos para este mes.',
              style: TextStyles.plusJakartaSansBody1,
            ),
        ],
      ),
    );
  }
}
