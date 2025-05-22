import 'package:eventify/calendar/domain/entities/events/appointment_event.dart';
import 'package:eventify/calendar/domain/entities/events/conference_event.dart';
import 'package:eventify/calendar/domain/entities/events/exam_event.dart';
import 'package:eventify/calendar/domain/entities/events/meeting_event.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/colors/colors.dart';
// Importa tu AddEventScreen para la navegación
import 'package:eventify/calendar/presentation/screen/add_event_screen.dart';

class DailiesEventScreen extends StatefulWidget {
  final DateTime selectedDate;

  const DailiesEventScreen({super.key, required this.selectedDate});

  @override
  State<DailiesEventScreen> createState() => _DailiesEventScreenState();
}

class _DailiesEventScreenState extends State<DailiesEventScreen> {
  late EventViewModel _eventViewModel;
  List<Event> _dailyEvents = [];

  @override
  void initState() {
    super.initState();
    _eventViewModel = sl<EventViewModel>();
    _loadDailyEvents();
  }

  // Helper para normalizar DateTime a solo componentes de fecha
  DateTime _normalizeDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<void> _loadDailyEvents() async {
    try {
      await _eventViewModel.getEventsForCurrentUser();
      setState(() {
        _dailyEvents = _eventViewModel.events.where((event) {
          return event.dateTime != null &&
              _normalizeDate(event.dateTime!.toDate()) ==
                  _normalizeDate(widget.selectedDate);
        }).toList();
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load daily events: ${e.toString()}')),
        );
      }
    }
  }

  // Marcador de posición para añadir/editar un evento
  void _onAddOrEditEvent({Event? event}) {
    // TODO: Implementar la navegación a AddEventScreen para añadir/editar.
    // Pasarías el objeto 'event' si estás editando, o null si estás añadiendo uno nuevo.
    // Después de regresar de AddEventScreen, recargarías los eventos.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddEventScreen(), // Navega a tu AddEventScreen
      ),
    ).then((_) {
      _loadDailyEvents(); // Recarga los eventos al regresar de AddEventScreen
    });
  }

  // Marcador de posición para eliminar un evento
  void _onDeleteEvent(Event event) {
    // TODO: Implementar la lógica de eliminación.
    // Esto podría implicar mostrar un diálogo de confirmación y luego
    // llamar a un método en tu EventViewModel para eliminar el evento,
    // seguido de la recarga de los eventos.
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The delete functionality for "${event.title}" is not implemented yet.')),
      );
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
            // Opción de volver atrás: simplemente hace pop de la pantalla actual
            Navigator.of(context).pop();
          },
        ),
        title: ShiningTextAnimation(
          text: DateFormat('EEEE, dd MMMM', 'es').format(widget.selectedDate).toUpperCase(), // Fecha en español
          style: TextStyles.urbanistBody1,
          shineColor: const Color(0xFFCBCBCB),
        ),
        backgroundColor: headerColor,
        foregroundColor: outlineColor,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: kToolbarHeight,
      ),
      body: _dailyEvents.isEmpty
          ? Center(
              child: Text(
                'There are no events for this day.', // Message in English
                style: TextStyles.urbanistSubtitle1.copyWith(color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Events for ${DateFormat('dd/MM/yyyy').format(widget.selectedDate)} (${_dailyEvents.length})',
                    style: TextStyles.urbanistSubtitle1.copyWith(fontSize: 18),
                  ),
                    const SizedBox(height: 10.0),
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _dailyEvents.map((event) {
                      String eventTypeString = 'N/A';
                      if (event is MeetingEvent) {
                      eventTypeString = 'Meeting';
                      } else if (event is ExamEvent) {
                      eventTypeString = 'Exam';
                      } else if (event is ConferenceEvent) {
                      eventTypeString = 'Conference';
                      } else if (event is AppointmentEvent) {
                      eventTypeString = 'Appointment';
                      } else {
                      eventTypeString = 'Task';
                      }
                      String formattedDateTime = event.dateTime != null
                      ? DateFormat('HH:mm').format(event.dateTime!.toDate())
                      : 'N/A';

                      return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Expanded(
                              child: Text(
                              event.title,
                              style: TextStyles.plusJakartaSansBody1
                                .copyWith(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                onPressed: () => _onAddOrEditEvent(event: event),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _onDeleteEvent(event),
                              ),
                              ],
                            ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Time: $formattedDateTime',
                            style: TextStyles.plusJakartaSansBody2,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Type: $eventTypeString',
                            style: TextStyles.plusJakartaSansBody2,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Description: ${event.description ?? 'N/A'}',
                            style: TextStyles.plusJakartaSansBody2,
                          ),
                          Text(
                            'Priority: ${event.priority.toString().split('.').last.toUpperCase()}',
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
        onPressed: () => _onAddOrEditEvent(), // Llama al placeholder
        backgroundColor: AppColors.primaryContainer,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}