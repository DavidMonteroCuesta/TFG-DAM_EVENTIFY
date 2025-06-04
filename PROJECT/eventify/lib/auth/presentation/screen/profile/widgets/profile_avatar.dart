// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

// Constantes para valores numéricos y estilos en ProfileAvatar
const double kProfileAvatarLeft = 16.0;
const double kProfileAvatarBlurSigma = 10.0;
const double kProfileAvatarBackgroundOpacity = 0.35;
const double kProfileAvatarFontSize = 32.0;

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
      left: kProfileAvatarLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(avatarRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: kProfileAvatarBlurSigma,
            sigmaY: kProfileAvatarBlurSigma,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.profileMediumGrey.withOpacity(
                kProfileAvatarBackgroundOpacity,
              ),
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
                    fontSize: kProfileAvatarFontSize,
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
