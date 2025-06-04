import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

const double kAuthLayoutMaxWidth = 400.0;
const double kAuthLayoutPaddingHorizontal = 24.0;
const double kAuthLayoutPaddingVertical = 32.0;
const double kAuthLayoutTitleFontSize = 40.0;
const double kAuthLayoutTitleLetterSpacing = 1.5;
const int kAuthLayoutTitleDurationMs = 2000;
const double kAuthLayoutTitleSpacing = 32.0;
const double kAuthLayoutFooterSpacing = 24.0;
const double kAuthLayoutFooterTextFontSize = 14.0;
const double kAuthLayoutFooterTextSpacing = 16.0;

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: kAuthLayoutMaxWidth),
              padding: EdgeInsets.symmetric(
                horizontal: kAuthLayoutPaddingHorizontal,
                vertical: kAuthLayoutPaddingVertical,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShiningTextAnimation(
                    text: AppStrings.appTitleEventify(context),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: kAuthLayoutTitleFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: kAuthLayoutTitleLetterSpacing,
                    ),
                    duration: Duration(
                      milliseconds: kAuthLayoutTitleDurationMs,
                    ),
                    shineColor: AppColors.accentColor400,
                  ),
                  SizedBox(height: kAuthLayoutTitleSpacing),
                  child,
                  SizedBox(height: kAuthLayoutFooterSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onLeftFooterTap,
                        child: Text(
                          leftFooterText,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: kAuthLayoutFooterTextFontSize,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(width: kAuthLayoutFooterTextSpacing),
                      GestureDetector(
                        onTap: onRightFooterTap,
                        child: Text(
                          rightFooterText,
                          style: TextStyle(
                            color: AppColors.footerRightTextColor,
                            fontSize: kAuthLayoutFooterTextFontSize,
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
