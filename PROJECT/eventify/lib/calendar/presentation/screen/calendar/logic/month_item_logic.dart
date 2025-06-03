import 'dart:ui';

import 'package:eventify/common/theme/colors/app_colors.dart';

// Lógica para determinar el color de la notificación según la cantidad de eventos en el mes.
class MonthItemLogic {
  static const int _oneEvent = 1;
  static const int _fewEventsMin = 2;
  static const int _fewEventsMax = 3;
  static const int _severalEventsMin = 4;
  static const int _severalEventsMax = 7;
  static const int _manyEvents = 8;

  // Devuelve el color de la notificación según el número de eventos.
  static Color? getNotificationColor(int count) {
    if (count == _oneEvent) {
      return AppColors.primary;
    } else if (count >= _fewEventsMin && count <= _fewEventsMax) {
      return AppColors.calendarAccentColor;
    } else if (count >= _severalEventsMin && count <= _severalEventsMax) {
      return AppColors.notificationOrange;
    } else if (count >= _manyEvents) {
      return AppColors.deleteButtonColor;
    }
    return null;
  }
}
