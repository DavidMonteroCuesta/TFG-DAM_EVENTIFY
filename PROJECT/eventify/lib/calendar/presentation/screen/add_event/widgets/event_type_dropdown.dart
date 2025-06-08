import 'package:eventify/calendar/domain/enums/events_type_enum.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

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

  static const double _inputBorderRadius = 10.0;
  static const double _inputFocusedBorderWidth = 1.5;
  static const double _inputContentPaddingH = 16.0;
  static const double _inputContentPaddingV = 12.0;

  @override
  Widget build(BuildContext context) {
    // Dropdown para seleccionar el tipo de evento con estilos personalizados
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
                    value.localizedName(context),
                    style: TextStyles.plusJakartaSansBody1,
                  ),
                );
              })
              .toList(),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.plusJakartaSansSubtitle2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputBorderRadius),
          borderSide: BorderSide(
            color: secondaryColor,
            width: _inputFocusedBorderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: _inputContentPaddingH,
          vertical: _inputContentPaddingV,
        ),
        filled: true,
        fillColor: AppColors.inputFillColor,
      ),
      style: TextStyles.plusJakartaSansBody1,
    );
  }
}
