import 'package:eventify/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:eventify/common/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'social_sign_in_button.dart';
import 'package:eventify/common/constants/app_strings.dart';

const double kSocialSignInButtonGoogleIconHeight = 18.0;
const double kSocialSignInButtonSpacing = 10.0;

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpViewModel = Provider.of<SignUpViewModel>(context, listen: false);

    return Column(
      children: [
        // Botón de inicio de sesión con Google
        SocialSignInButton(
          icon: Image.asset(AppAssets.googleIcon, height: kSocialSignInButtonGoogleIconHeight),
          text: AppStrings.socialSignInGoogleText(context),
          onPressed: () async {
            await signUpViewModel.signInWithGoogle(context);
          },
        ),
        SizedBox(height: kSocialSignInButtonSpacing),
        // Botón de inicio de sesión con Apple (deshabilitado)
        SocialSignInButton(
          icon: const Icon(Icons.apple),
          text: AppStrings.socialSignInAppleText(context),
          onPressed: null,
        ),
      ],
    );
  }
}
