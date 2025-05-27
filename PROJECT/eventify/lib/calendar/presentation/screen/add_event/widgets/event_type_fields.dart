// Widget for the location, subject, and with-person fields in AddEventScreen
import 'package:flutter/material.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';

class EventTypeFields extends StatelessWidget {
  final EventType selectedEventType;
  final TextEditingController locationController;
  final TextEditingController subjectController;
  final TextEditingController withPersonController;
  final bool withPersonYesNo;
  final ValueChanged<bool?> onWithPersonChanged;
  final Color secondaryColor;
  final Color onSecondaryColor;
  final Color outlineColor;
  final String locationLabel;
  final String subjectLabel;
  final String withPersonYesNoLabel;
  final String withPersonLabel;

  const EventTypeFields({
    super.key,
    required this.selectedEventType,
    required this.locationController,
    required this.subjectController,
    required this.withPersonController,
    required this.withPersonYesNo,
    required this.onWithPersonChanged,
    required this.secondaryColor,
    required this.onSecondaryColor,
    required this.outlineColor,
    required this.locationLabel,
    required this.subjectLabel,
    required this.withPersonYesNoLabel,
    required this.withPersonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedEventType == EventType.meeting ||
            selectedEventType == EventType.conference ||
            selectedEventType == EventType.appointment)
          TextFormField(
            controller: locationController,
            style: const TextStyle(
              fontSize: 16.0,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: locationLabel,
              labelStyle: TextStyles.plusJakartaSansSubtitle2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: secondaryColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              filled: true,
              fillColor: AppColors.inputFillColor,
            ),
          ),
        if (selectedEventType == EventType.exam)
          TextFormField(
            controller: subjectController,
            style: const TextStyle(
              fontSize: 16.0,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: subjectLabel,
              labelStyle: TextStyles.plusJakartaSansSubtitle2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: secondaryColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              filled: true,
              fillColor: AppColors.inputFillColor,
            ),
          ),
        if (selectedEventType == EventType.appointment)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Text(
                    withPersonYesNoLabel,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Checkbox(
                    value: withPersonYesNo,
                    onChanged: onWithPersonChanged,
                    activeColor: secondaryColor,
                    checkColor: onSecondaryColor,
                    side: BorderSide(color: outlineColor),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Visibility(
                  visible: withPersonYesNo,
                  child: TextFormField(
                    controller: withPersonController,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: withPersonLabel,
                      labelStyle: TextStyles.plusJakartaSansSubtitle2,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: secondaryColor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      filled: true,
                      fillColor: AppColors.inputFillColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
