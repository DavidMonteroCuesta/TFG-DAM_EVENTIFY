import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/colors.dart'; // Import AppColors

class EventifyAuthLayout extends StatelessWidget {
  final Widget child;
  final VoidCallback? onLeftFooterTap;
  final VoidCallback? onRightFooterTap;
  final String leftFooterText;
  final String rightFooterText;

  const EventifyAuthLayout({
    super.key,
    required this.child,
    required this.leftFooterText,
    required this.rightFooterText,
    this.onLeftFooterTap,
    this.onRightFooterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Using AppColors
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShiningTextAnimation(
                    text: AppStrings.appTitleEventify(context),
                    style: const TextStyle(
                      color: AppColors.textPrimary, // Using AppColors
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    duration: const Duration(milliseconds: 2000),
                    shineColor: AppColors.accentColor400, // Using AppColors
                  ),
                  const SizedBox(height: 32),

                  child,

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onLeftFooterTap,
                        child: Text(
                          leftFooterText,
                          style: const TextStyle(
                            color: AppColors.textPrimary, // Using AppColors
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: onRightFooterTap,
                        child: Text(
                          rightFooterText,
                          style: const TextStyle(
                            color: AppColors.footerRightTextColor, // Using AppColors
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
