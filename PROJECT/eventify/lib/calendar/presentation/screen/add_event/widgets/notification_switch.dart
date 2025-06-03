// ignore_for_file: deprecated_member_use

import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

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

  static const double _activeColorOpacity = 0.7;
  static const double _inactiveTrackOpacity = 0.6;
  static const double _labelSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    // Switch de notificación con opacidades y espaciado personalizados
    return Row(
      children: [
        Switch(
          value: value,
          activeColor: activeColor.withOpacity(_activeColorOpacity),
          inactiveTrackColor: AppColors.switchInactiveTrackColor.withOpacity(
            _inactiveTrackOpacity,
          ),
          inactiveThumbColor: AppColors.switchInactiveThumbColor,
          onChanged: onChanged,
        ),
        const SizedBox(width: _labelSpacing),
        Expanded(
          child: Text(label, style: TextStyles.plusJakartaSansSubtitle2),
        ),
      ],
    );
  }
}
