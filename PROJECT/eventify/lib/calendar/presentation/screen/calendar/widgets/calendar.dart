import 'package:eventify/calendar/presentation/screen/calendar/widgets/month_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/calendar/presentation/screen/calendar/logic/calendar_event_loader.dart';

class Calendar extends StatefulWidget {
  final Function(int monthIndex)? onMonthSelected;
  final int currentYear;

  const Calendar({super.key, this.onMonthSelected, required this.currentYear});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
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

    if (eventViewModel.isLoading && _monthlyEventCounts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventViewModel.errorMessage != null) {
      return Center(
        child: Text(
          '${AppInternalConstants.calendarErrorMessagePrefix}${eventViewModel.errorMessage}',
        ),
      );
    }

    if (_months == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(children: _buildMonthRows(MediaQuery.of(context).size.width));
  }

  List<Widget> _buildMonthRows(double screenWidth) {
    final List<Widget> rows = [];
    int itemsPerRow = 3;
    if (screenWidth >= 1000) {
      itemsPerRow = 4;
    } else if (screenWidth > 600) {
      itemsPerRow = 3;
    }

    List<String> displayedMonths = _months!;

    final List<int> notifications = List.generate(
      12,
      (index) => _monthlyEventCounts[index + 1] ?? 0,
    );

    for (int i = 0; i < displayedMonths.length; i += itemsPerRow) {
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
              screenWidth < 400
                  ? const TextStyle(fontSize: 12) // Apply smaller font size
                  : null, // Default style
        ),
      );
    }
    return rows;
  }
}
