import 'package:flutter/material.dart';

class MonthItem extends StatelessWidget {
  final String monthName;
  final int notificationCount;

  const MonthItem({super.key, required this.monthName, required this.notificationCount});

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
    return null; // Si es 0, devolvemos null para no mostrar el indicador
  }

  @override
  Widget build(BuildContext context) {
    final notificationColor = _getNotificationColor(notificationCount);

    return Container(
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (notificationColor != null) // Mostrar solo si notificationColor no es null
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}