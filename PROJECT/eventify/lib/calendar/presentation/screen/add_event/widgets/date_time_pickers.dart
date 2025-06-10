import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickers extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;
  final String dateLabel;
  final String timeLabel;
  final String? dateErrorText;
  final String? timeErrorText;
  final Color secondaryColor;

  static const double _inputBorderRadius = 10.0;
  static const double _inputFocusedBorderWidth = 1.5;
  static const double _inputContentPaddingH = 16.0;
  static const double _inputContentPaddingV = 12.0;
  static const double _dateTimeFieldSpacing = 15.0;
  static const int _dummyYear = 2024;
  static const int _dummyMonth = 1;
  static const int _dummyDay = 1;

  const DateTimePickers({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.dateLabel,
    required this.timeLabel,
    this.dateErrorText,
    this.timeErrorText,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    // Widget para seleccionar fecha y hora
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onSelectDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: dateLabel,
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
                errorText: dateErrorText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: _inputContentPaddingH,
                  vertical: _inputContentPaddingV,
                ),
                filled: true,
                fillColor: AppColors.inputFillColor,
              ),
              child: Text(
                selectedDate != null
                    ? DateFormat('yyyy/MM/dd').format(selectedDate!)
                    : dateLabel,
                style: TextStyles.plusJakartaSansBody1,
              ),
            ),
          ),
        ),
        const SizedBox(width: _dateTimeFieldSpacing),
        Expanded(
          child: InkWell(
            onTap: onSelectTime,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: timeLabel,
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
                errorText: timeErrorText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: _inputContentPaddingH,
                  vertical: _inputContentPaddingV,
                ),
                filled: true,
                fillColor: AppColors.inputFillColor,
              ),
              child: Text(
                selectedTime != null
                    ? DateFormat('hh:mm a').format(
                      DateTime(
                        _dummyYear,
                        _dummyMonth,
                        _dummyDay,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      ),
                    )
                    : '--:--',
                style: TextStyles.plusJakartaSansBody1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
