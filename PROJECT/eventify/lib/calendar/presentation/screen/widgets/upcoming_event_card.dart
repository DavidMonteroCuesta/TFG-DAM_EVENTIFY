import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';

class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String type;
  final DateTime date;
  final String priority;
  final String description;
  final VoidCallback? onEdit;
  final VoidCallback? onTapCard;

  const UpcomingEventCard({
    super.key,
    required this.title,
    required this.type,
    required this.date,
    required this.priority,
    required this.description,
    this.onEdit,
    this.onTapCard,
  });

  String _getTranslatedEventType(BuildContext context, String typeString) {
    switch (typeString.toLowerCase()) {
      case AppInternalConstants.eventTypeMeeting:
        return AppStrings.searchEventTypeMeetingDisplay(context).toUpperCase();
      case AppInternalConstants.eventTypeExam:
        return AppStrings.searchEventTypeExamDisplay(context).toUpperCase();
      case AppInternalConstants.eventTypeConference:
        return AppStrings.searchEventTypeConferenceDisplay(
          context,
        ).toUpperCase();
      case AppInternalConstants.eventTypeAppointment:
        return AppStrings.searchEventTypeAppointmentDisplay(
          context,
        ).toUpperCase();
      case AppInternalConstants.eventTypeTask:
      default:
        return AppStrings.searchEventTypeTaskDisplay(context).toUpperCase();
    }
  }

  String _getTranslatedPriority(BuildContext context, String priorityString) {
    switch (priorityString.toLowerCase()) {
      case AppInternalConstants.priorityValueCritical:
        return AppStrings.priorityDisplayCritical(context);
      case AppInternalConstants.priorityValueHigh:
        return AppStrings.priorityDisplayHigh(context);
      case AppInternalConstants.priorityValueMedium:
        return AppStrings.priorityDisplayMedium(context);
      case AppInternalConstants.priorityValueLow:
        return AppStrings.priorityDisplayLow(context);
      default:
        return priorityString;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color outlineColor = Color(0xFFE0E0E0);

    return InkWell(
      onTap: onTapCard,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: outlineColor.withOpacity(0.3), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.plusJakartaSansBody1.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _getTranslatedEventType(
                    context,
                    type.split('.').last,
                  ), // Pass context to helper
                  style: TextStyles.plusJakartaSansBody2.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            Text(
              '${AppStrings.upcomingEventDatePrefix(context)}${DateFormat('yyyy/MM/dd HH:mm').format(date)}', // Pass context
              style: TextStyles.plusJakartaSansBody2.copyWith(
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8.0),

            Text(
              '${AppStrings.upcomingEventPriorityPrefix(context)}${_getTranslatedPriority(context, priority.split('.').last)}', // Pass context to helper
              style: TextStyles.plusJakartaSansBody2.copyWith(
                color: Colors.yellow,
              ),
            ),
            const SizedBox(height: 8.0),

            Flexible(
              child: Text(
                '${AppStrings.upcomingEventDescriptionPrefix(context)}${description.isNotEmpty ? description : AppInternalConstants.upcomingEventDescriptionEmpty}', // Pass context
                style: TextStyles.plusJakartaSansBody2.copyWith(
                  color: Colors.grey[300],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
