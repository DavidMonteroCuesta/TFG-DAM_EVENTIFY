import 'package:eventify/src/widgets/log/animations/ani_left_to_right.dart' show AnimatedScreenState;
import 'package:eventify/src/widgets/log/elements/auth_subtitle.dart' show AuthSubtitle;
import 'package:eventify/src/widgets/log/elements/auth_title.dart' show AuthTitle;
import 'package:eventify/src/widgets/log/elements/custom_text_field.dart' show CustomTextField;
import 'package:eventify/src/widgets/log/elements/primary_button.dart' show PrimaryButton;
import 'package:eventify/src/widgets/log/login/elements/forgot_passwd_option.dart' show ForgotPasswordOption;
import 'package:eventify/src/widgets/log/elements/social_sign_in_buttons.dart' show SocialSignInButtons;
import 'package:eventify/src/widgets/log/elements/login_auth_layout.dart' show EventifyAuthLayout;
import 'package:eventify/src/widgets/log/signup/sign_up_screen.dart' show SignUpScreen;
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends AnimatedScreenState<SignInScreen> {
  double _emailOffset = 0.0;
  double _passwordOffset = 0.0;
  double _signInButtonOffset = 0.0;

  @override
  void initializeAnimationOffsets() {
    _emailOffset = -screenWidth;
    _passwordOffset = -screenWidth;
    _signInButtonOffset = -screenWidth;
  }

  @override
  void startAnimations() {
    animateElement(_emailOffset, 300, (value) {
      _emailOffset = value;
    });
    animateElement(_passwordOffset, 400, (value) {
      _passwordOffset = value;
    });
    animateElement(_signInButtonOffset, 1, (value) {
      _signInButtonOffset = value;
    });
  }

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
            transform: Matrix4.translationValues(_signInButtonOffset, 0.0, 0.0),
            child: const PrimaryButton(text: 'Sign In', onPressed: null),
          ),
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