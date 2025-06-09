// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/utils/dates/months_enum.dart';

const double kProfileHeaderBlurSigma = 10.0;
const double kProfileHeaderBorderRadius = 0.0;
const double kProfileHeaderOpacity = 0.80;
const double kProfileHeaderCloseButtonPaddingRight = 16.0;
const double kProfileHeaderCloseButtonPaddingTop = 20.0;
const double kProfileHeaderCloseButtonRadius = 24.0;
const double kProfileHeaderCloseButtonInnerBlurSigma = 10.0;
const double kProfileHeaderCloseButtonInnerOpacity = 0.28;
const double kProfileHeaderDatePaddingLeft = 96.0;
const double kProfileHeaderDatePaddingTop = 60.0;

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

  String _getLocalizedDate(BuildContext context) {
    try {
      final date = DateTime.now();
      final day = date.day;
      final month = date.month;
      final year = date.year;
      final localizedMonth = Month.fromInt(month).localizedName(context);
      return '$day $localizedMonth $year';
    } catch (_) {
      return currentDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kProfileHeaderBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: kProfileHeaderBlurSigma,
          sigmaY: kProfileHeaderBlurSigma,
        ),
        child: Container(
          width: double.infinity,
          height: headerHeight,
          color: AppColors.profileHeaderBackground.withOpacity(
            kProfileHeaderOpacity,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: kProfileHeaderCloseButtonPaddingRight,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      kProfileHeaderCloseButtonRadius,
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: kProfileHeaderCloseButtonInnerBlurSigma,
                        sigmaY: kProfileHeaderCloseButtonInnerBlurSigma,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.profileMediumGrey.withOpacity(
                            kProfileHeaderCloseButtonInnerOpacity,
                          ),
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
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: kProfileHeaderDatePaddingLeft),
                  child: ShiningTextAnimation(
                    text: _getLocalizedDate(context),
                    style: TextStyles.urbanistBody1.copyWith(
                      color: AppColors.shineEffectColor,
                    ),
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
