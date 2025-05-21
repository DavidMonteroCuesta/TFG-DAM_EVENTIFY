import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String type;
  final DateTime date;
  final String priority;
  final String description;

  const UpcomingEventCard({
    super.key,
    required this.title,
    required this.type,
    required this.date,
    required this.priority,
    required this.description,
  });

  Color? _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orangeAccent;
      case 'high':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEE MMM d HH:mm', 'en_US').format(date);
    final priorityColor = _getPriorityColor(priority);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _truncateText(title, 25),
                style: TextStyles.urbanistH6,
              ),
              Text(
                type.toUpperCase(),
                style: TextStyles.plusJakartaSansBody2,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formattedDate,
            style: TextStyles.plusJakartaSansBody2,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Priority: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              Text(
                priority,
                style: TextStyle(color: priorityColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _truncateText(description, 60),
            style: TextStyles.plusJakartaSansBody2,
          ),
        ],
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength - 3)}...';
    }
  }
}