import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

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

  Color? _getNotificationColor(int count) {
    if (count == 1) {
      return Colors.green;
    } else if (count > 1 && count <= 3) {
      return Colors.orangeAccent;
    } else if (count >= 4 && count <= 7) {
      return Colors.orange;
    } else if (count > 7) {
      return Colors.red;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final notificationColor = _getNotificationColor(notificationCount);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.grey[850],
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
                      color: Colors.black,
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
