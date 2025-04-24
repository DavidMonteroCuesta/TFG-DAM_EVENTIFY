import 'package:eventify/common/theme/colors/colors.dart';
import 'package:eventify/common/widgets/calendar/widgets/buttons/chat_button.dart';
import 'package:eventify/common/widgets/calendar/widgets/buttons/calendar_toggle_button.dart';
import 'package:eventify/common/widgets/calendar/widgets/buttons/profile_button.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final VoidCallback onToggleCalendar;
  final bool isMonthlyView;
  final VoidCallback? onProfileTap;
  final VoidCallback? onChatTap;

  const Footer({
    super.key,
    required this.onToggleCalendar,
    required this.isMonthlyView,
    this.onProfileTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final footerHeightPercentage = 0.08;
    final footerHeight = screenHeight * footerHeightPercentage;

    return Container(
      height: footerHeight,
      color: AppColors.footerBackground, // Usando el color constante
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.star_border, color: AppColors.footerIconColor, size: 24.0),
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