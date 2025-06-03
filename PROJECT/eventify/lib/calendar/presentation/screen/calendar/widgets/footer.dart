// ignore_for_file: deprecated_member_use

import 'package:eventify/calendar/presentation/screen/calendar/widgets/buttons/calendar_toggle_button.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/buttons/chat_button.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/buttons/profile_button.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/calendar/presentation/screen/calendar/logic/footer_logic.dart';

class Footer extends StatelessWidget {
  final VoidCallback onToggleCalendar;
  final bool isMonthlyView;
  final VoidCallback? onProfileTap;
  final VoidCallback? onChatTap;
  final VoidCallback onResetToCurrent;

  const Footer({
    super.key,
    required this.onToggleCalendar,
    required this.isMonthlyView,
    this.onProfileTap,
    this.onChatTap,
    required this.onResetToCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final footerHeight = FooterLogic.getFooterHeight(context);

    return Container(
      height: footerHeight,
      color: AppColors.footerBackground.withOpacity(0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(
              Icons.today,
              color: AppColors.footerIconColor,
              size: 24.0,
            ),
            onPressed: onResetToCurrent,
            tooltip: AppStrings.footerReturnToCurrentMonthTooltip(context),
          ),
          ChatButton(size: 32),
          Transform.scale(
            scale: 1,
            child: CalendarToggleButton(
              onToggleCalendar: onToggleCalendar,
              isMonthlyView: isMonthlyView,
            ),
          ),
          ProfileButton(size: 32),
        ],
      ),
    );
  }
}
