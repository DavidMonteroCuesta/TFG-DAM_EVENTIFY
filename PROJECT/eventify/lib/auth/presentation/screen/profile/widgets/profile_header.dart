import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String currentDate;
  final VoidCallback onClose;
  final double headerHeight;

  const ProfileHeader({
    super.key,
    required this.currentDate,
    required this.onClose,
    this.headerHeight = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          height: headerHeight,
          color: AppColors.profileHeaderBackground.withOpacity(0.80),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.profileMediumGrey.withOpacity(0.28),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: onClose,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 96.0, top: 60.0),
                child: ShiningTextAnimation(
                  text: currentDate,
                  style: TextStyles.urbanistBody1.copyWith(
                    color: AppColors.shineEffectColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
