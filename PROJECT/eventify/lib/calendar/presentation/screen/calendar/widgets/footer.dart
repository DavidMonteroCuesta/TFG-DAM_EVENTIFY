// ignore_for_file: deprecated_member_use

import 'package:eventify/calendar/presentation/screen/calendar/logic/footer_logic.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/buttons/calendar_toggle_button.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/buttons/chat_button.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/buttons/profile_button.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

// Widget que muestra el pie de página del calendario, con botones de navegación y acciones rápidas.
class Footer extends StatelessWidget {
  static const double _footerOpacity = 0.8;
  static const double _footerIconSize = 24.0;
  static const double _actionButtonSize = 32.0;

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

    // Pie de página con botones para volver al mes actual, chat, alternar vista y perfil.
    return Container(
      height: footerHeight,
      color: AppColors.footerBackground.withOpacity(_footerOpacity),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(
              Icons.today,
              color: AppColors.footerIconColor,
              size: _footerIconSize,
            ),
            onPressed: onResetToCurrent,
            tooltip: AppStrings.footerReturnToCurrentMonthTooltip(context),
          ),
          ChatButton(size: _actionButtonSize),
          Transform.scale(
            scale: 1,
            child: CalendarToggleButton(
              onToggleCalendar: onToggleCalendar,
              isMonthlyView: isMonthlyView,
            ),
          ),
          ProfileButton(size: _actionButtonSize),
        ],
      ),
    );
  }
}
