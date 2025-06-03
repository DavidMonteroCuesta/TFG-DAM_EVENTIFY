// ignore_for_file: deprecated_member_use

import 'package:eventify/calendar/presentation/screen/calendar/logic/upcoming_event_card_logic.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCard,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppColors.outlineColorLight.withOpacity(0.3),
            width: 1.0,
          ),
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
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  UpcomingEventCardLogic.getTranslatedEventType(
                    context,
                    type.split('.').last,
                  ),
                  style: TextStyles.plusJakartaSansBody2.copyWith(
                    color: AppColors.textGrey400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            Text(
              '${AppStrings.upcomingEventDatePrefix(context)}${DateFormat('yyyy/MM/dd HH:mm').format(date)}',
              style: TextStyles.plusJakartaSansBody2.copyWith(
                color: AppColors.textGrey400,
              ),
            ),
            const SizedBox(height: 8.0),

            Text(
              '${AppStrings.upcomingEventPriorityPrefix(context)}${UpcomingEventCardLogic.getTranslatedPriority(context, priority.split('.').last)}',
              style: TextStyles.plusJakartaSansBody2.copyWith(
                color: AppColors.priorityTextColorDynamic,
              ),
            ),
            const SizedBox(height: 8.0),

            Flexible(
              child: Text(
                '${AppStrings.upcomingEventDescriptionPrefix(context)}${description.isNotEmpty ? description : AppInternalConstants.upcomingEventDescriptionEmpty}',
                style: TextStyles.plusJakartaSansBody2.copyWith(
                  color: AppColors.textSubtitle1Grey,
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
