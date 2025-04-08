// ignore: file_names
import 'package:flutter/material.dart';

class MonthButton extends StatelessWidget {
  const MonthButton({
    super.key,
    required this.monthName,
    required this.backgroundColor,
    required this.textColor,
    this.textStyle = const TextStyle(fontSize: 16), // Default style in case textStyle is not provided
  });

  final String monthName;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: backgroundColor.withOpacity(0.75), // Apply opacity directly on background
        borderRadius: BorderRadius.circular(10), // Optional: add rounded corners for a nice effect
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          monthName,
          style: textStyle.copyWith(color: textColor), // Apply passed text style and ensure text color
        ),
      ),
    );
  }
}
