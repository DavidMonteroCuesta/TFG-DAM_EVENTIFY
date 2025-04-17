import 'package:eventify/common/widgets/auth/widgets/social_sign_in_button.dart' show SocialSignInButton;
import 'package:flutter/material.dart';

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SocialSignInButton(
          icon: Image.asset('assets/icons/google.png', height: 18),
          text: 'Continue with Google',
          onPressed: null,
        ),
        const SizedBox(height: 10),
        SocialSignInButton(
          icon: const Icon(Icons.apple), 
          text: 'Continue with Apple',
          onPressed: null,
        ),
      ],
    );
  }
}