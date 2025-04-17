import 'package:eventify/common/widgets/auth/widgets/social_sign_in_button.dart'
    show SocialSignInButton;
import 'package:eventify/generated/l10n.dart';
import 'package:flutter/material.dart';

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    return Column(
      children: [
        SocialSignInButton(
          icon: Image.asset(
            'assets/icons/google.png',
            height: 18,
          ),
          text: localizations.continueWithGoogle,
          onPressed: null,
        ),
        const SizedBox(height: 10),
        SocialSignInButton(
          icon: const Icon(Icons.apple),
          text: localizations.continueWithApple,
          onPressed: null,
        ),
      ],
    );
  }
}