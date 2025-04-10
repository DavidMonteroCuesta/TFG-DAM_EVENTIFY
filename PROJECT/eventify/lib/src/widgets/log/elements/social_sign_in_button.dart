// widgets/log/widgets/social_sign_in_button.dart
import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final String text;
  final IconData icon;
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
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.grey),
        ),
        icon: Icon(icon),
        label: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}