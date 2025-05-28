import 'dart:ui';
import 'package:eventify/common/theme/colors/app_colors.dart';

class MonthItemLogic {
  static Color? getNotificationColor(int count) {
    if (count == 1) {
      return AppColors.primary;
    } else if (count > 1 && count <= 3) {
      return AppColors.calendarAccentColor;
    } else if (count >= 4 && count <= 7) {
      return AppColors.notificationOrange;
    } else if (count > 7) {
      return AppColors.deleteButtonColor;
    }
    return null;
  }
}
