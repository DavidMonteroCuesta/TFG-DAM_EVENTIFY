import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'day_item.dart';

class MonthView extends StatefulWidget {
  final DateTime currentMonth;
  final bool compact;

  const MonthView({super.key, required this.currentMonth, this.compact = false});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  late List<DateTime> _daysInMonth;
  late int _firstDayOfMonthWeekday;

  @override
  void initState() {
    super.initState();
    _generateDays();
  }

  @override
  void didUpdateWidget(covariant MonthView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentMonth != oldWidget.currentMonth) {
      _generateDays();
    }
  }

  void _generateDays() {
    final firstDayOfMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month, 1);
    final lastDayOfMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month + 1, 0);
    _firstDayOfMonthWeekday = (firstDayOfMonth.weekday % 7);
    final numberOfDays = lastDayOfMonth.day;

    _daysInMonth = List.generate(numberOfDays, (i) => DateTime(widget.currentMonth.year, widget.currentMonth.month, i + 1));
  }

  @override
  Widget build(BuildContext context) {
    final monthAbbreviationStyle = const TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontSize: 14,
    );
    const daySpacing = 2.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMM', 'es_ES').format(widget.currentMonth).toUpperCase(),
            style: monthAbbreviationStyle,
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: daySpacing,
                mainAxisSpacing: daySpacing,
                childAspectRatio: 0.5, // Reducimos aún más para dar más altura a las filas
              ),
              itemCount: _daysInMonth.length + _firstDayOfMonthWeekday,
              itemBuilder: (context, index) {
                if (index < _firstDayOfMonthWeekday) {
                  return const SizedBox();
                }
                final day = _daysInMonth[index - _firstDayOfMonthWeekday].day;
                final now = DateTime.now();
                final isToday = now.year == widget.currentMonth.year &&
                    now.month == widget.currentMonth.month &&
                    now.day == day;

                const hasEvent = false;

                return DayItem(day: day, hasEvent: hasEvent, isToday: isToday, compact: true);
              },
            ),
          ),
        ],
      ),
    );
  }
}