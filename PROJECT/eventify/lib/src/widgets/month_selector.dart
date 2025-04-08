import 'package:flutter/material.dart';

class MonthButton extends StatelessWidget {
  const MonthButton({
    super.key,
    required this.monthName,
    required this.backgroundColor,
    required this.textColor,
    required this.textStyle,
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
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          monthName,
          style: textStyle.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class MonthSelector extends StatelessWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí accedes al tema de tu aplicación (en FlutterFlow, se accede de manera similar)
    final Color monthButtonBackgroundColor = Theme.of(context).primaryColor;
    final Color monthButtonTextColor = Colors.white;
    const TextStyle monthButtonTextStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      letterSpacing: 0.0,
      fontWeight: FontWeight.w600,
    );

    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MonthButton(
                monthName: 'JANUARY',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'FEBRUARY',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'MARCH',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'APRIL',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'MAY',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'JUNE',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'JULY',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'AUGUST',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'SEPTEMBER',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'OCTOBER',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'NOVEMBER',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'DECEMBER',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
            ].expand((monthButton) => [monthButton, const SizedBox(width: 8)]).toList(), // Esto añade espacio entre los botones
          ),
        ),
      ),
    );
  }
}
