import 'package:eventify/calendar/presentation/screen/widgets/month_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/calendar/domain/entities/event.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final List<String> months = const [
    'JANUARY', 'FEBRUARY', 'MARCH',
    'APRIL', 'MAY', 'JUNE',
    'JULY', 'AUGUST', 'SEPTEMBER',
    'OCTOBER', 'NOVEMBER', 'DECEMBER',
  ];

  Map<int, int> _monthlyEventCounts = {};
  late EventViewModel _eventViewModel;

  @override
  void initState() {
    super.initState();
    _eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthlyEventCounts();
    });
  }

  Future<void> _loadMonthlyEventCounts() async {
    if (!mounted) return;

    final int currentYear = DateTime.now().year;
    Map<int, int> counts = { for (var i = 1; i <= 12; i++) i : 0 }; // Inicializa todos los meses a 0

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _eventViewModel.setLoading(true);
      }
    });

    try {
      // NUEVO: Obtener todos los eventos del año en una sola llamada
      await _eventViewModel.getEventsForCurrentUserAndYear(currentYear);
      if (!mounted) return;

      final List<Event> allEventsForYear = _eventViewModel.events;

      // Procesar los eventos localmente para contar por mes
      for (final event in allEventsForYear) {
        if (event.dateTime != null) {
          final int month = event.dateTime!.toDate().month;
          counts[month] = (counts[month] ?? 0) + 1;
        }
      }

      setState(() {
        _monthlyEventCounts = counts;
      });
    } catch (e) {
      print('Error loading monthly event counts: $e');
      // El errorMessage ya se maneja en el ViewModel, aquí podrías mostrar un SnackBar si es necesario
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _eventViewModel.setLoading(false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);

    if (eventViewModel.isLoading && _monthlyEventCounts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventViewModel.errorMessage != null) {
      return Center(child: Text('Error: ${eventViewModel.errorMessage}'));
    }

    return Column(
      children: _buildMonthRows(MediaQuery.of(context).size.width),
    );
  }

  List<Widget> _buildMonthRows(double screenWidth) {
    final List<Widget> rows = [];
    int itemsPerRow = 3;
    if (screenWidth >= 900) {
      itemsPerRow = 3;
    } else if (screenWidth > 600) {
      itemsPerRow = 3;
    }

    final List<int> notifications = List.generate(12, (index) => _monthlyEventCounts[index + 1] ?? 0);

    for (int i = 0; i < months.length; i += itemsPerRow) {
      final end = i + itemsPerRow > months.length ? months.length : i + itemsPerRow;
      final rowMonths = months.sublist(i, end);
      final rowNotifications = notifications.sublist(i, end);
      rows.add(
        MonthRow(rowMonths: rowMonths, rowNotifications: rowNotifications),
      );
    }
    return rows;
  }
}
