import 'package:flutter/material.dart';
import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';

class EventTypeDropdown extends StatelessWidget {
  final EventType selectedEventType;
  final ValueChanged<EventType?> onChanged;
  final String labelText;
  final Color secondaryColor;

  const EventTypeDropdown({
    super.key,
    required this.selectedEventType,
    required this.onChanged,
    required this.labelText,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<EventType>(
      value: selectedEventType,
      onChanged: onChanged,
      items:
          EventType.values
              .where((type) => type != EventType.all)
              .map<DropdownMenuItem<EventType>>((EventType value) {
                return DropdownMenuItem<EventType>(
                  value: value,
                  child: Text(
                    value.toString().split('.').last.toUpperCase(),
                    style: TextStyles.plusJakartaSansBody1,
                  ),
                );
              })
              .toList(),
      decoration: InputDecoration(
        labelText: labelText,
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
      style: TextStyles.plusJakartaSansBody1,
    );
  }
}
