import 'package:eventify/calendar/presentation/screen/calendar/logic/month_item_logic.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

class MonthItem extends StatelessWidget {
  final String monthName;
  final int notificationCount;
  final VoidCallback? onTap;
  const MonthItem({
    super.key,
    required this.monthName,
    required this.notificationCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final notificationColor = MonthItemLogic.getNotificationColor(
      notificationCount,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1265,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.calendarBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  monthName.toUpperCase(),
                  style: TextStyles.plusJakartaSansBody1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (notificationColor != null)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: notificationColor,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Text(
                    notificationCount.toString(),
                    style: TextStyles.plusJakartaSansButton.copyWith(
                      color: AppColors.textOnLightBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
