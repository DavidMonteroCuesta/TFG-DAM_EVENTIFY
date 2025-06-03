import 'package:eventify/calendar/presentation/screen/calendar/logic/calendar_event_loader.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/month_row.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widget que muestra la vista principal del calendario con filas de meses y contadores de eventos.
class Calendar extends StatefulWidget {
  final Function(int monthIndex)? onMonthSelected;
  final int currentYear;

  const Calendar({super.key, this.onMonthSelected, required this.currentYear});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  static const int _monthsInYear = 12;
  static const int _defaultItemsPerRow = 3;
  static const int _wideScreenItemsPerRow = 4;
  static const double _smallScreenWidth = 400.0;
  static const double _wideScreenMinWidth = 1000.0;
  static const double _mediumScreenMinWidth = 600.0;
  static const double _smallFontSize = 12.0;
  static const int _firstMonthIndex = 1;
  static const int _initialMonthIndex = 0;
  static const int _initialEventCount = 0;

  List<String>? _months;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _months ??= [
      AppStrings.monthJanuary(context),
      AppStrings.monthFebruary(context),
      AppStrings.monthMarch(context),
      AppStrings.monthApril(context),
      AppStrings.monthMay(context),
      AppStrings.monthJune(context),
      AppStrings.monthJuly(context),
      AppStrings.monthAugust(context),
      AppStrings.monthSeptember(context),
      AppStrings.monthOctober(context),
      AppStrings.monthNovember(context),
      AppStrings.monthDecember(context),
    ];
  }

  @override
  void didUpdateWidget(covariant Calendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentYear != oldWidget.currentYear) {
      _loadMonthlyEventCounts();
    }
  }

  // Carga los conteos de eventos mensuales desde el modelo de eventos.
  Future<void> _loadMonthlyEventCounts() async {
    if (!mounted) return;
    final int yearToLoad = widget.currentYear;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _eventViewModel.setLoading(true);
      }
    });
    try {
      final counts = await CalendarEventLoader.loadMonthlyEventCounts(
        _eventViewModel,
        yearToLoad,
      );
      if (!mounted) return;
      setState(() {
        _monthlyEventCounts = counts;
      });
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

    // Muestra un indicador de carga mientras se están cargando los eventos.
    if (eventViewModel.isLoading && _monthlyEventCounts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Muestra un mensaje de error si ocurre un problema al cargar los eventos.
    if (eventViewModel.errorMessage != null) {
      return Center(
        child: Text(
          '${AppInternalConstants.calendarErrorMessagePrefix}${eventViewModel.errorMessage}',
        ),
      );
    }

    // Muestra un indicador de carga si los meses aún no están disponibles.
    if (_months == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Construye la columna de filas de meses, mostrando el calendario y los contadores de eventos.
    return Column(children: _buildMonthRows(MediaQuery.of(context).size.width));
  }

  // Construye las filas de meses para mostrar en el calendario.
  List<Widget> _buildMonthRows(double screenWidth) {
    final List<Widget> rows = [];
    int itemsPerRow = _defaultItemsPerRow;
    if (screenWidth >= _wideScreenMinWidth) {
      itemsPerRow = _wideScreenItemsPerRow;
    } else if (screenWidth > _mediumScreenMinWidth) {
      itemsPerRow = _defaultItemsPerRow;
    }

    List<String> displayedMonths = _months!;

    final List<int> notifications = List.generate(
      _monthsInYear,
      (index) =>
          _monthlyEventCounts[index + _firstMonthIndex] ?? _initialEventCount,
    );

    for (
      int i = _initialMonthIndex;
      i < displayedMonths.length;
      i += itemsPerRow
    ) {
      final end =
          i + itemsPerRow > displayedMonths.length
              ? displayedMonths.length
              : i + itemsPerRow;
      final rowMonths = displayedMonths.sublist(i, end);
      final rowNotifications = notifications.sublist(i, end);
      rows.add(
        MonthRow(
          rowMonths: rowMonths,
          rowNotifications: rowNotifications,
          onMonthTap: widget.onMonthSelected,
          textStyle:
              screenWidth < _smallScreenWidth
                  ? const TextStyle(fontSize: _smallFontSize)
                  : null,
        ),
      );
    }
    return rows;
  }
}
