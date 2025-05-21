import 'package:eventify/calendar/presentation/screen/widgets/month_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/calendar/domain/entities/event.dart';

class Calendar extends StatefulWidget {
  final Function(int monthIndex)? onMonthSelected;
  final int currentYear; // Nuevo: Año actual pasado desde CalendarScreen

  const Calendar({super.key, this.onMonthSelected, required this.currentYear});

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
      _loadMonthlyEventCounts(); // Carga inicial con el año actual
    });
  }

  @override
  void didUpdateWidget(covariant Calendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el año actual cambia, recarga los conteos de eventos
    if (widget.currentYear != oldWidget.currentYear) {
      _loadMonthlyEventCounts();
    }
  }

  Future<void> _loadMonthlyEventCounts() async {
    if (!mounted) return;

    // Usa el año pasado por el widget
    final int yearToLoad = widget.currentYear;
    Map<int, int> counts = { for (var i = 1; i <= 12; i++) i : 0 };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _eventViewModel.setLoading(true);
      }
    });

    try {
      await _eventViewModel.getEventsForCurrentUserAndYear(yearToLoad);
      if (!mounted) return;

      final List<Event> allEventsForYear = _eventViewModel.events;

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
      print('Error loading monthly event counts for year $yearToLoad: $e');
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
        MonthRow(
          rowMonths: rowMonths,
          rowNotifications: rowNotifications,
          onMonthTap: widget.onMonthSelected,
        ),
      );
    }
    return rows;
  }
}
