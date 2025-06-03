// ignore_for_file: use_build_context_synchronously

import 'package:eventify/calendar/presentation/screen/calendar/logic/monthly_calendar_logic.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Widget que muestra un calendario mensual interactivo con los eventos del usuario.
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

  static const double _calendarBorderRadius = 10.0;
  static const double _calendarPadding = 16.0;
  static const double _daysOfWeekSpacing = 12.0;
  static const double _daysGridSpacing = 10.0;
  static const double _eventsSpacing = 16.0;
  static const int _daysInWeek = 7;
  static const int _firstDayOffsetIfSunday = 6;
  static const int _firstDayOffsetElse = 1;
  static const int _firstDayNum = 1;
  static const int _lastDayOffset = 0;
  static const int _monthChangeDay = 1;

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
    _firstDayOfMonth = DateTime(
      _focusedDay.year,
      _focusedDay.month,
      _firstDayNum,
    );
    _lastDayOfMonth = DateTime(
      _focusedDay.year,
      _focusedDay.month + 1,
      _lastDayOffset,
    );
    _daysInMonth = List.generate(
      _lastDayOfMonth.day,
      (i) => DateTime(_focusedDay.year, _focusedDay.month, i + _firstDayNum),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month - 1,
        _monthChangeDay,
      );
      _loadEventsForMonth();
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
        _monthChangeDay,
      );
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
    // Construye la UI del calendario mensual, mostrando días, eventos y navegación de meses.
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
        color: AppColors.calendarBackground,
        borderRadius: BorderRadius.circular(_calendarBorderRadius),
      ),
      padding: const EdgeInsets.all(_calendarPadding),
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
                ),
                onPressed: _goToPreviousMonth,
              ),
              Text(
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
          const SizedBox(height: _daysOfWeekSpacing),
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
          const SizedBox(height: _daysGridSpacing),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  _daysInMonth.length +
                  (_firstDayOfMonth.weekday == _daysInWeek
                      ? _firstDayOffsetIfSunday
                      : _firstDayOfMonth.weekday - _firstDayOffsetElse),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _daysInWeek,
              ),
              itemBuilder: (context, index) {
                final int weekdayOffset =
                    _firstDayOfMonth.weekday == _daysInWeek
                        ? _firstDayOffsetIfSunday
                        : _firstDayOfMonth.weekday - _firstDayOffsetElse;

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
                      color: isToday ? AppColors.todayHighlightColor : null,
                      shape: isToday ? BoxShape.circle : BoxShape.rectangle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color:
                              isToday || hasEvent
                                  ? AppColors.calendarAccentColor
                                  : AppColors.textPrimary,
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
          const SizedBox(height: _eventsSpacing),
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
