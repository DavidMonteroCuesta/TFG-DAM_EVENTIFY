import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

const double kPrimaryButtonWidth = double.infinity;
const double kPrimaryButtonHeight = 48.0;
const double kPrimaryButtonBorderRadius = 8.0;
const double kPrimaryButtonFontSize = 16.0;

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kPrimaryButtonWidth,
      height: kPrimaryButtonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor400,
          foregroundColor: AppColors.elevatedButtonForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kPrimaryButtonBorderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: kPrimaryButtonFontSize,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
