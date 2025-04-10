import 'package:flutter/material.dart';

class AuthTitle extends StatelessWidget {
  final String text;
  final double? fontSize;

  const AuthTitle({super.key, required this.text, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey.shade200,
        fontSize: fontSize ?? 28,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}