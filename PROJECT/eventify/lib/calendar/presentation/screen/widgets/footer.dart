import 'package:eventify/calendar/presentation/screen/widgets/buttons/calendar_toggle_button.dart';
import 'package:eventify/calendar/presentation/screen/widgets/buttons/chat_button.dart';
import 'package:eventify/calendar/presentation/screen/widgets/buttons/profile_button.dart';
import 'package:eventify/common/theme/colors/colors.dart';
import 'package:flutter/material.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final footerHeightPercentage = 0.08;
    final footerHeight = screenHeight * footerHeightPercentage;

    return Container(
      height: footerHeight,
      color: AppColors.footerBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.today, color: AppColors.footerIconColor, size: 24.0),
            onPressed: onResetToCurrent,
            tooltip: 'Return to actual month',
          ),
          ChatButton(
            size: 32,
          ),
          Transform.scale(
            scale: 1,
            child: CalendarToggleButton(
              onToggleCalendar: onToggleCalendar,
              isMonthlyView: isMonthlyView,
            ),
          ),
          ProfileButton(
            size: 32,
          ),
        ],
      ),
    );
  }
}