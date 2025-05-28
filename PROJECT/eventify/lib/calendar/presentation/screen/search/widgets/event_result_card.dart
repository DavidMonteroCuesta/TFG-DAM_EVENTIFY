import 'package:flutter/material.dart';
import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/constants/app_strings.dart';

class EventResultCard extends StatelessWidget {
  final Event event;
  final String eventTypeString;
  final String formattedDateTime;
  final String Function(String) getTranslatedPriorityDisplay;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double width;
  final BuildContext contextForStrings;

  const EventResultCard({
    super.key,
    required this.event,
    required this.eventTypeString,
    required this.formattedDateTime,
    required this.getTranslatedPriorityDisplay,
    required this.onEdit,
    required this.onDelete,
    required this.width,
    required this.contextForStrings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: width,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: AppColors.outlineColorLight.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: TextStyles.plusJakartaSansBody1.copyWith(
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.editIconColor,
                        ),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.deleteIconColor,
                        ),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                '${AppStrings.searchDateAndTimePrefix(contextForStrings)}$formattedDateTime',
                style: TextStyles.plusJakartaSansBody2,
              ),
              const SizedBox(height: 4.0),
              Text(
                '${AppStrings.searchTypePrefix(contextForStrings)}$eventTypeString',
                style: TextStyles.plusJakartaSansBody2,
              ),
              const SizedBox(height: 4.0),
              Text(
                '${AppStrings.searchDescriptionPrefix(contextForStrings)}${event.description ?? "-"}',
                style: TextStyles.plusJakartaSansBody2,
              ),
              Text(
                '${AppStrings.searchPriorityPrefix(contextForStrings)}${getTranslatedPriorityDisplay(event.priority.toString().split('.').last)}',
                style: TextStyles.plusJakartaSansBody2.copyWith(
                  color: AppColors.priorityTextColorDynamic,
                ),
              ),
              if (event.location != null && event.location!.isNotEmpty)
                Text(
                  '${AppStrings.searchLocationPrefix(contextForStrings)}${event.location}',
                  style: TextStyles.plusJakartaSansBody2,
                ),
              if (event.subject != null && event.subject!.isNotEmpty)
                Text(
                  '${AppStrings.searchSubjectPrefix(contextForStrings)}${event.subject}',
                  style: TextStyles.plusJakartaSansBody2,
                ),
              if (event.withPerson != null && event.withPerson!.isNotEmpty)
                Text(
                  '${AppStrings.searchWithPersonPrefix(contextForStrings)}${event.withPerson}',
                  style: TextStyles.plusJakartaSansBody2,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
