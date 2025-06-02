import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String firstLetter;
  final double avatarRadius;
  final double avatarTopPosition;

  const ProfileAvatar({
    super.key,
    required this.firstLetter,
    this.avatarRadius = 40.0,
    this.avatarTopPosition = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: avatarTopPosition,
      left: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(avatarRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.profileMediumGrey.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.transparent,
              child: Center(
                child: Text(
                  firstLetter,
                  style: TextStyles.urbanistSubtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
