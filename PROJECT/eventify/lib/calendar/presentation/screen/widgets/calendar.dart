import 'package:eventify/calendar/presentation/screen/widgets/month_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart'; // Importa el ViewModel

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

  Map<int, int> _monthlyEventCounts = {}; // Mapa para almacenar el número de eventos por mes
  late EventViewModel _eventViewModel;

  @override
  void initState() {
    super.initState();
    // Inicializa el ViewModel. listen: false porque solo lo necesitamos para llamar métodos, no para reconstruir aquí.
    _eventViewModel = Provider.of<EventViewModel>(context, listen: false);

    // Mueve la llamada a _loadMonthlyEventCounts a un post-frame callback
    // para evitar setState() durante la fase de construcción.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthlyEventCounts();
    });
  }

  Future<void> _loadMonthlyEventCounts() async {
    // Check if the widget is still mounted before proceeding with async operations that might call setState
    if (!mounted) return;

    final int currentYear = DateTime.now().year;
    Map<int, int> counts = {};

    // Notifica que la carga ha comenzado, también en un post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _eventViewModel.setLoading(true);
      }
    });


    try {
      for (int month = 1; month <= 12; month++) {
        await _eventViewModel.getEventsForCurrentUserAndMonth(currentYear, month);
        // Ensure widget is still mounted before updating state after async call
        if (!mounted) return;
        counts[month] = _eventViewModel.events.length;
      }
      setState(() {
        _monthlyEventCounts = counts;
      });
    } catch (e) {
      // El errorMessage ya se maneja en el ViewModel, aquí solo podrías loguear o mostrar un SnackBar si es necesario
      print('Error loading monthly event counts: $e');
    } finally {
      // Notifica que la carga ha terminado, incluso si hubo un error
      // También en un post-frame callback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _eventViewModel.setLoading(false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en isLoading y errorMessage del ViewModel
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

    // Convertir el mapa de conteos a una lista de notificaciones en el orden correcto
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
