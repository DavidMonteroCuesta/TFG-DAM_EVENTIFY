import 'package:eventify/calendar/presentation/screen/calendar/logic/month_item_logic.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

/// Widget que representa un mes individual en la fila de meses, mostrando el nombre y el contador de notificaciones.
class MonthItem extends StatelessWidget {
  static const double _containerHeightFactor = 0.1265;
  static const double _horizontalMargin = 5.0;
  static const double _borderRadius = 12.0;
  static const double _boxShadowOffsetY = 4.0;
  static const double _boxShadowBlur = 6.0;
  static const double _paddingAll = 8.0;
  static const double _notificationTop = 5.0;
  static const double _notificationRight = 5.0;
  static const double _notificationPadding = 6.0;
  static const double _notificationBoxShadowOffsetX = 0.0;
  static const double _notificationBoxShadowOffsetY = 1.0;
  static const double _notificationBoxShadowBlur = 3.0;
  static const double _notificationFontSize = 12.0;
  static const double _boxShadowOffsetX = 0.0;

  final String monthName;
  final int notificationCount;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  const MonthItem({
    super.key,
    required this.monthName,
    required this.notificationCount,
    this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final notificationColor = MonthItemLogic.getNotificationColor(
      notificationCount,
    );

    // Contenedor interactivo que muestra el nombre del mes y, si corresponde, el contador de notificaciones.
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * _containerHeightFactor,
        margin: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
        decoration: BoxDecoration(
          color: AppColors.calendarBackground,
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(_boxShadowOffsetX, _boxShadowOffsetY),
              blurRadius: _boxShadowBlur,
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(_paddingAll),
                child: Text(
                  monthName.toUpperCase(),
                  style: textStyle ?? TextStyles.plusJakartaSansBody1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (notificationColor != null)
              Positioned(
                top: _notificationTop,
                right: _notificationRight,
                child: Container(
                  padding: const EdgeInsets.all(_notificationPadding),
                  decoration: BoxDecoration(
                    color: notificationColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(
                          _notificationBoxShadowOffsetX,
                          _notificationBoxShadowOffsetY,
                        ),
                        blurRadius: _notificationBoxShadowBlur,
                      ),
                    ],
                  ),
                  child: Text(
                    notificationCount.toString(),
                    style: TextStyles.plusJakartaSansButton.copyWith(
                      color: AppColors.textOnLightBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: _notificationFontSize,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
