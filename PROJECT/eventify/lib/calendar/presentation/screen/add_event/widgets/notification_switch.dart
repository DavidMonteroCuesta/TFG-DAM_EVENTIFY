// Widget for the notification switch in AddEventScreen
import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';

class NotificationSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final Color activeColor;

  const NotificationSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          activeColor: activeColor.withOpacity(0.7),
          inactiveTrackColor: AppColors.switchInactiveTrackColor.withOpacity(
            0.6,
          ),
          inactiveThumbColor: AppColors.switchInactiveThumbColor,
          onChanged: onChanged,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(label, style: TextStyles.plusJakartaSansSubtitle2),
        ),
      ],
    );
  }
}
