import 'package:eventify/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'social_sign_in_button.dart';
import 'package:eventify/common/constants/app_strings.dart'; // Import AppStrings

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpViewModel = Provider.of<SignUpViewModel>(context, listen: false);

    return Column(
      children: [
        SocialSignInButton(
          icon: Image.asset('assets/icons/google.png', height: 18),
          text: AppStrings.socialSignInGoogleText,
          onPressed: () async {
            await signUpViewModel.signInWithGoogle(context);
          },
        ),
        const SizedBox(height: 10),
        SocialSignInButton(
          icon: const Icon(Icons.apple),
          text: AppStrings.socialSignInAppleText,
          onPressed: null,
        ),
      ],
    );
  }
}
