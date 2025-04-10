import 'package:eventify/src/widgets/log/animations/ani_left_to_right.dart' show AnimatedScreenState;
import 'package:eventify/src/widgets/log/elements/auth_subtitle.dart' show AuthSubtitle;
import 'package:eventify/src/widgets/log/elements/auth_title.dart' show AuthTitle;
import 'package:eventify/src/widgets/log/elements/custom_text_field.dart' show CustomTextField;
import 'package:eventify/src/widgets/log/elements/primary_button.dart' show PrimaryButton;
import 'package:eventify/src/widgets/log/elements/social_sign_in_buttons.dart' show SocialSignInButtons;
import 'package:eventify/src/widgets/log/elements/login_auth_layout.dart' show EventifyAuthLayout;
import 'package:eventify/src/widgets/log/login/sign_in_screen.dart' show SignInScreen;
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends AnimatedScreenState<SignUpScreen> {
  double _emailOffset = 0.0;
  double _passwordOffset = 0.0;
  double _confirmPasswordOffset = 0.0;
  double _getStartedButtonOffset = 0.0;

  @override
  void initializeAnimationOffsets() {
    _emailOffset = -screenWidth;
    _passwordOffset = -screenWidth;
    _confirmPasswordOffset = -screenWidth;
    _getStartedButtonOffset = -screenWidth;
  }

  @override
  void startAnimations() {
    animateElement(_emailOffset, 300, (value) {
      _emailOffset = value;
    });
    animateElement(_passwordOffset, 400, (value) {
      _passwordOffset = value;
    });
    animateElement(_confirmPasswordOffset, 500, (value) {
      _confirmPasswordOffset = value;
    });
    animateElement(_getStartedButtonOffset, 1, (value) {
      _getStartedButtonOffset = value;
    });
  }

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
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_emailOffset, 0.0, 0.0),
            child: const CustomTextField(hintText: 'Email'),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_passwordOffset, 0.0, 0.0),
            child: const CustomTextField(hintText: 'Password', obscure: true),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_confirmPasswordOffset, 0.0, 0.0),
            child: const CustomTextField(hintText: 'Confirm Password', obscure: true),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_getStartedButtonOffset, 0.0, 0.0),
            child: const PrimaryButton(text: 'Get Started', onPressed: null),
          ),
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