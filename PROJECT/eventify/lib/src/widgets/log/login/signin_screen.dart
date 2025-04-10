import 'package:eventify/src/widgets/log/elements/auth_subtitle.dart' show AuthSubtitle;
import 'package:eventify/src/widgets/log/elements/auth_title.dart' show AuthTitle;
import 'package:eventify/src/widgets/log/elements/custom_text_field.dart' show CustomTextField;
import 'package:eventify/src/widgets/log/elements/primary_button.dart' show PrimaryButton;
import 'package:eventify/src/widgets/log/login/elements/forgot_passwd_option.dart' show ForgotPasswordOption;
import 'package:eventify/src/widgets/log/elements/social_sign_in_buttons.dart' show SocialSignInButtons;
import 'package:eventify/src/widgets/log/elements/login_auth_layout.dart' show EventifyAuthLayout;
import 'package:eventify/src/widgets/log/signup/signup_screen.dart' show SignUpScreen;
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EventifyAuthLayout(
      leftFooterText: 'Create Account',
      rightFooterText: 'Log In',
      onLeftFooterTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignUpScreen()),
        );
      },
      onRightFooterTap: () {
        // Opcional
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthTitle(text: 'Welcome Back'),
          const SizedBox(height: 8),
          const AuthSubtitle(text: 'Fill out the information below in order to access your account.'),
          const SizedBox(height: 24),
          const CustomTextField(hintText: 'Email'),
          const SizedBox(height: 16),
          const CustomTextField(hintText: 'Password', obscure: true),
          const SizedBox(height: 16),
          const PrimaryButton(text: 'Sign In', onPressed: null),
          const SizedBox(height: 16),
          Text(
            'Or sign in with',
            style: TextStyle(
              color: Colors.grey[500],              
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const SocialSignInButtons(),
          const SizedBox(height: 16),
          const ForgotPasswordOption(),
        ],
      ),
    );
  }
}