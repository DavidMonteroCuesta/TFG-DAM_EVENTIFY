import 'package:eventify/common/utils/dates/months_enum.dart';

class DateFormatter {
  static String getCurrentDateFormatted() {
    final now = DateTime.now();
    final year = now.year;
    final day = now.day;
    final currentMonth = Month.values[now.month - 1];

    return "$year ${day.toString().padLeft(2, '0')} ${currentMonth.abbreviation}";
  }
}