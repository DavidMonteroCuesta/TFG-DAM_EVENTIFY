import 'package:flutter/material.dart';

class DayItem extends StatelessWidget {
  final int day;
  final bool hasEvent;
  final bool isToday;
  final bool compact;

  const DayItem({
    super.key,
    required this.day,
    this.hasEvent = false,
    this.isToday = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final dayTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      color: isToday ? Colors.redAccent : Colors.white,
    );
    const eventIndicatorSize = 2.0;
    const eventIndicatorPadding = EdgeInsets.only(top: 2.0);

    return Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Text(
            day.toString(),
            style: dayTextStyle,
          ),
          if (hasEvent)
            Padding(
              padding: eventIndicatorPadding,
              child: Container(
                width: eventIndicatorSize,
                height: eventIndicatorSize,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}