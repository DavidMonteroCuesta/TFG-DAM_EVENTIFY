import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

class AuthTitle extends StatelessWidget {
  final String text;
  final double? fontSize;

  const AuthTitle({super.key, required this.text, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.authTitleColor,
        fontSize: fontSize ?? 28,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
