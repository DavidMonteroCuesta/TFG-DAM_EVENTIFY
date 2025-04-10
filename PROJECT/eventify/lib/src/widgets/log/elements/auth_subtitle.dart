import 'package:flutter/material.dart';

class AuthSubtitle extends StatelessWidget {
  final String text;

  const AuthSubtitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
      ),
    );
  }
}