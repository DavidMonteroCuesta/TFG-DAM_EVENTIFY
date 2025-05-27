import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';

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
                errorText: dateErrorText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
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
        const SizedBox(width: 15.0),
        Expanded(
          child: InkWell(
            onTap: onSelectTime,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: timeLabel,
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
                errorText: timeErrorText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                filled: true,
                fillColor: AppColors.inputFillColor,
              ),
              child: Text(
                selectedTime != null
                    ? DateFormat('hh:mm a').format(
                      DateTime(
                        2024,
                        1,
                        1,
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
