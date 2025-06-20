import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

const double kAuthSubtitleFontSize = 14.0;

class AuthSubtitle extends StatelessWidget {
  final String text;

  const AuthSubtitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textGrey400,
        fontSize: kAuthSubtitleFontSize,
      ),
    );
  }
}
