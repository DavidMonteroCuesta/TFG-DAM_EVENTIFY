import 'package:eventify/src/widgets/months/elements/calendar.dart';
import 'package:eventify/src/widgets/months/elements/footer.dart';
import 'package:eventify/src/widgets/months/elements/header.dart';
import 'package:flutter/material.dart';

class MonthsScreen extends StatelessWidget {
  const MonthsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final desktopWidthThresholdMedium = 600;

    final headerFooterHeightPercentage = screenWidth > desktopWidthThresholdMedium ? 0.07 : 0.1;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * headerFooterHeightPercentage,
            child: const Header(),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: _getCalendarWidth(screenWidth),
                child: Calendar(),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * headerFooterHeightPercentage,
            child: const Footer(),
          ),
        ],
      ),
    );
  }

  double _getCalendarWidth(double screenWidth) {
    if (screenWidth >= 900) {
      return screenWidth / 3;
    } else if (screenWidth > 600) {
      return screenWidth / 2;
    } else {
      return screenWidth - 32;
    }
  }
}