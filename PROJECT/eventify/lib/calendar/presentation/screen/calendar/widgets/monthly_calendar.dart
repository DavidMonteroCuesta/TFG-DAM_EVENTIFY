// ignore_for_file: use_build_context_synchronously

import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/calendar/presentation/screen/calendar/logic/monthly_calendar_logic.dart';

class MonthlyCalendar extends StatefulWidget {
  final DateTime initialFocusedDay;
  final ValueChanged<DateTime>? onDaySelected;

  const MonthlyCalendar({
    super.key,
    required this.initialFocusedDay,
    this.onDaySelected,
  });

  @override
  State<MonthlyCalendar> createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  late DateTime _focusedDay;
  late DateTime _firstDayOfMonth;
  late DateTime _lastDayOfMonth;
  late List<DateTime> _daysInMonth;
  late EventViewModel _eventViewModel;
  List<Map<String, dynamic>> _eventsForCurrentMonth = [];
  Set<DateTime> _datesWithEvents = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay;
    _eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    _loadEventsForMonth();
  }

  @override
  void didUpdateWidget(covariant MonthlyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFocusedDay.year != oldWidget.initialFocusedDay.year ||
        widget.initialFocusedDay.month != oldWidget.initialFocusedDay.month ||
        widget.initialFocusedDay.day != oldWidget.initialFocusedDay.day ||
        widget.key != oldWidget.key) {
      setState(() {
        _focusedDay = widget.initialFocusedDay;
        _loadEventsForMonth();
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
      _loadEventsForMonth();
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
      _loadEventsForMonth();
    });
  }

  Future<void> _loadEventsForMonth() async {
    _updateCalendarDays();
    try {
      final eventsData = await _eventViewModel.getEventsForCurrentUserAndMonth(
        _focusedDay.year,
        _focusedDay.month,
      );
      if (mounted) {
        setState(() {
          _eventsForCurrentMonth = eventsData;
          _datesWithEvents = MonthlyCalendarLogic.extractDatesWithEvents(
            eventsData,
          );
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppInternalConstants.monthlyCalendarErrorLoadingEvents}${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current device locale
    final String currentLocale = Localizations.localeOf(context).languageCode;

    final daysOfWeek = [
      AppStrings.monthlyCalendarMondayAbbr(context),
      AppStrings.monthlyCalendarTuesdayAbbr(context),
      AppStrings.monthlyCalendarWednesdayAbbr(context),
      AppStrings.monthlyCalendarThursdayAbbr(context),
      AppStrings.monthlyCalendarFridayAbbr(context),
      AppStrings.monthlyCalendarSaturdayAbbr(context),
      AppStrings.monthlyCalendarSundayAbbr(context),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.calendarBackground, // Using AppColors
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
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.textPrimary,
                ), // Using AppColors
                onPressed: _goToPreviousMonth,
              ),
              Text(
                // Use the currentLocale for formatting the month name
                DateFormat('MMMM', currentLocale).format(_focusedDay),
                style: TextStyles.urbanistH6,
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textPrimary,
                ), // Using AppColors
                onPressed: _goToNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                daysOfWeek
                    .map(
                      (day) => Text(
                        day,
                        style: TextStyle(color: AppColors.calendarAccentColor),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  _daysInMonth.length +
                  (_firstDayOfMonth.weekday == 7
                      ? 6
                      : _firstDayOfMonth.weekday - 1),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                final int weekdayOffset =
                    _firstDayOfMonth.weekday == 7
                        ? 6
                        : _firstDayOfMonth.weekday - 1;

                if (index < weekdayOffset) {
                  return const SizedBox();
                }
                final day = _daysInMonth[index - weekdayOffset];
                final isToday =
                    day.year == DateTime.now().year &&
                    day.month == DateTime.now().month &&
                    day.day == DateTime.now().day;
                final hasEvent = _datesWithEvents.contains(day);

                return GestureDetector(
                  onTap: () {
                    widget.onDaySelected?.call(day);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isToday
                              ? AppColors
                                  .todayHighlightColor // Using AppColors
                              : null,
                      shape: isToday ? BoxShape.circle : BoxShape.rectangle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color:
                              isToday || hasEvent
                                  ? AppColors
                                      .calendarAccentColor // Using AppColors
                                  : AppColors.textPrimary, // Using AppColors
                          fontWeight:
                              isToday || hasEvent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_eventsForCurrentMonth.isNotEmpty)
            Text(
              '${AppStrings.monthlyCalendarEventsForMonthPrefix(context)}${_eventsForCurrentMonth.length}',
              style: TextStyles.plusJakartaSansBody1,
            )
          else
            Text(
              AppStrings.monthlyCalendarNoEventsForMonth(context),
              style: TextStyles.plusJakartaSansBody1,
            ),
        ],
      ),
    );
  }
}
