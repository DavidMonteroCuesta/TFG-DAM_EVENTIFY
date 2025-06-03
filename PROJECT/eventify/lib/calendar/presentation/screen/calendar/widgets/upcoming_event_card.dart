// ignore_for_file: deprecated_member_use

import 'package:eventify/calendar/presentation/screen/calendar/logic/upcoming_event_card_logic.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget que muestra la tarjeta del próximo evento destacado en el calendario.
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

  static const double _borderRadius = 12.0;
  static const double _verticalMargin = 10.0;
  static const double _containerPadding = 20.0;
  static const double _boxShadowOpacity = 0.2;
  static const double _boxShadowSpreadRadius = 1.0;
  static const double _boxShadowBlurRadius = 5.0;
  static const double _boxShadowOffsetY = 3.0;
  static const double _sizedBoxHeight = 8.0;
  static const double _borderWidth = 1.0;
  static const double _titleFontSize = 18.0;
  static const double _boxShadowOffsetX = 0.0;
  static const double _outlineOpacity = 0.3;

  @override
  Widget build(BuildContext context) {
    // Tarjeta interactiva que muestra información relevante del próximo evento.
    return InkWell(
      onTap: onTapCard,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: _verticalMargin),
        padding: const EdgeInsets.all(_containerPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(
            color: AppColors.outlineColorLight.withOpacity(_outlineOpacity),
            width: _borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_boxShadowOpacity),
              spreadRadius: _boxShadowSpreadRadius,
              blurRadius: _boxShadowBlurRadius,
              offset: Offset(_boxShadowOffsetX, _boxShadowOffsetY),
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
                      fontSize: _titleFontSize,
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
            const SizedBox(height: _sizedBoxHeight),
            Text(
              '${AppStrings.upcomingEventDatePrefix(context)}${DateFormat('yyyy/MM/dd HH:mm').format(date)}',
              style: TextStyles.plusJakartaSansBody2.copyWith(
                color: AppColors.textGrey400,
              ),
            ),
            const SizedBox(height: _sizedBoxHeight),
            Text(
              '${AppStrings.upcomingEventPriorityPrefix(context)}${UpcomingEventCardLogic.getTranslatedPriority(context, priority.split('.').last)}',
              style: TextStyles.plusJakartaSansBody2.copyWith(
                color: AppColors.priorityTextColorDynamic,
              ),
            ),
            const SizedBox(height: _sizedBoxHeight),
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
