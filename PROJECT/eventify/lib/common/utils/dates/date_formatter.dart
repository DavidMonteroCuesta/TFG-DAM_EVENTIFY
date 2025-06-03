import 'package:eventify/common/utils/dates/months_enum.dart';

class DateFormatter {
  static const int _monthIndexOffset = 1;
  static const int _dayPadLength = 2;
  static const String _dayPadChar = '0';

  // Devuelve la fecha actual formateada
  static String getCurrentDateFormatted() {
    final now = DateTime.now();
    final year = now.year;
    final day = now.day;
    final currentMonth = Month.values[now.month - _monthIndexOffset];

    return "$year ${day.toString().padLeft(_dayPadLength, _dayPadChar)} ${currentMonth.abbreviation}";
  }

  // Devuelve el mes y año actual formateado
  static String getCurrentMonthAndYear() {
    final now = DateTime.now();
    final year = now.year;
    final currentMonth = Month.values[now.month - _monthIndexOffset];

    return "$year ${currentMonth.abbreviation}";
  }
}
