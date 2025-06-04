import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

const double kSocialSignInButtonWidth = double.infinity;

class SocialSignInButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;

  const SocialSignInButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kSocialSignInButtonWidth,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.outlinedButtonBorder),
        ),
        icon: icon,
        label: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}
