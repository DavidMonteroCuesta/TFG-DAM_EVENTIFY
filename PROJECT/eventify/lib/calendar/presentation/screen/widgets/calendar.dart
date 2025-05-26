import 'package:eventify/calendar/presentation/screen/widgets/month_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Timestamp
import 'package:eventify/common/constants/app_strings.dart'; // Import the AppStrings constants
import 'package:eventify/common/constants/app_internal_constants.dart'; // Import AppInternalConstants

class Calendar extends StatefulWidget {
  final Function(int monthIndex)? onMonthSelected;
  final int currentYear;

  const Calendar({super.key, this.onMonthSelected, required this.currentYear});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // Make 'months' nullable or initialize it in didChangeDependencies
  // It cannot be 'late final' if initialized using context in initState
  List<String>? _months; // Changed to nullable

  Map<int, int> _monthlyEventCounts = {};
  late EventViewModel _eventViewModel;

  @override
  void initState() {
    super.initState();
    _eventViewModel = Provider.of<EventViewModel>(context, listen: false);

    // REMOVED THE MONTHS INITIALIZATION FROM HERE
    // This was the source of the error.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthlyEventCounts();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize _months here, where context is guaranteed to be fully available.
    // This ensures localization data is ready.
    if (_months == null) { // Only initialize once
      _months = [
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
    Map<int, int> counts = { for (var i = 1; i <= 12; i++) i : 0 };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _eventViewModel.setLoading(true);
      }
    });

    try {
      await _eventViewModel.getEventsForCurrentUserAndYear(yearToLoad);
      if (!mounted) return;

      // allEventsForYear is now List<Map<String, dynamic>>
      final List<Map<String, dynamic>> allEventsForYear = _eventViewModel.events;

      for (final eventData in allEventsForYear) { // Iterate over maps
        final Timestamp? eventTimestamp = eventData['dateTime']; // Access dateTime from map
        if (eventTimestamp != null) {
          final int month = eventTimestamp.toDate().month; // Convert Timestamp to DateTime
          counts[month] = (counts[month] ?? 0) + 1;
        }
      }

      setState(() {
        _monthlyEventCounts = counts;
      });
    } catch (e) {
      print('${AppInternalConstants.calendarErrorLoadingMonthlyCountsPrint}$yearToLoad: $e'); // Using constant from AppInternalConstants
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
      return Center(child: Text('${AppInternalConstants.calendarErrorMessagePrefix}${eventViewModel.errorMessage}')); // Using constant from AppInternalConstants
    }

    // Add a check to ensure _months is not null before using it
    if (_months == null) {
      return const Center(child: CircularProgressIndicator()); // Or any other loading/error state
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

    // Use _months! because didChangeDependencies guarantees it's initialized
    for (int i = 0; i < _months!.length; i += itemsPerRow) {
      final end = i + itemsPerRow > _months!.length ? _months!.length : i + itemsPerRow;
      final rowMonths = _months!.sublist(i, end);
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