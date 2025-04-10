import 'package:eventify/src/widgets/log/elements/social_sign_in_button.dart' show SocialSignInButton;
import 'package:flutter/material.dart';

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SocialSignInButton( // Use the correct widget here
          icon: Icons.g_mobiledata,
          text: 'Continue with Google',
          onPressed: null, // You can pass your Google sign-in logic here
        ),
        SizedBox(height: 10),
        SocialSignInButton( // Use the correct widget here
          icon: Icons.apple,
          text: 'Continue with Apple',
          onPressed: null, // You can pass your Apple sign-in logic here
        ),
      ],
    );
  }
}