import 'package:eventify/src/widgets/log/elements/auth_subtitle.dart' show AuthSubtitle;
import 'package:eventify/src/widgets/log/elements/auth_title.dart' show AuthTitle;
import 'package:eventify/src/widgets/log/elements/custom_text_field.dart' show CustomTextField;
import 'package:eventify/src/widgets/log/elements/primary_button.dart' show PrimaryButton;
import 'package:eventify/src/widgets/log/elements/social_sign_in_buttons.dart' show SocialSignInButtons;
import 'package:eventify/src/widgets/log/elements/login_auth_layout.dart' show EventifyAuthLayout;
import 'package:eventify/src/widgets/log/login/signin_screen.dart' show SignInScreen;
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EventifyAuthLayout(
      leftFooterText: 'Create Account',
      rightFooterText: 'Log In',
      onRightFooterTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      },
      onLeftFooterTap: () {
        // Opcional
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthTitle(text: 'Create Account'),
          const SizedBox(height: 8),
          const AuthSubtitle(text: 'Let\'s get started by filling out the form below.'),
          const SizedBox(height: 24),
          const CustomTextField(hintText: 'Email'),
          const SizedBox(height: 16),
          const CustomTextField(hintText: 'Password', obscure: true),
          const SizedBox(height: 16),
          const CustomTextField(hintText: 'Confirm Password', obscure: true),
          const SizedBox(height: 16),
          const PrimaryButton(text: 'Get Started', onPressed: null), // Lógica en el futuro
          const SizedBox(height: 16),
          Text(
            'Or sign up with',
            style: TextStyle(
              color: Colors.grey[500],              
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const SocialSignInButtons(),
        ],
      ),
    );
  }
}