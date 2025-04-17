import 'package:eventify/auth/domain/presentation/screen/sign_up_screen.dart';
import 'package:eventify/generated/l10n.dart';
import 'package:eventify/src/widgets/calendar/months_screen.dart';
import 'package:eventify/common/widgets/auth/widgets/auth_subtitle.dart';
import 'package:eventify/common/widgets/auth/widgets/auth_title.dart';
import 'package:eventify/common/widgets/auth/widgets/custom_text_field.dart';
import 'package:eventify/common/widgets/auth/widgets/login_auth_layout.dart';
import 'package:eventify/common/widgets/auth/widgets/primary_button.dart';
import 'package:eventify/common/widgets/auth/widgets/social_sign_in_buttons.dart';
import 'package:eventify/common/widgets/auth/widgets/forgot_passwd_option.dart';
import 'package:eventify/common/widgets/auth/animations/ani_left_to_right.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/sign_in_view_model.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends SlideLeftToRightAnimationState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    animateElement(-screenWidth, 200, (value) {
      setState(() {
        _emailOffset = value;
      });
    });
    animateElement(-screenWidth, 300, (value) {
      setState(() {
        _passwordOffset = value;
      });
    });
    animateElement(-screenWidth, 1, (value) {
      setState(() {
        _signInButtonOffset = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final signInViewModel = Provider.of<SignInViewModel>(context);
    final localizations = S.of(context);

    return EventifyAuthLayout(
      leftFooterText: "create account", // Use the correct key
      rightFooterText: "log in",
      onLeftFooterTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignUpScreen()),
        );
      },
      onRightFooterTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTitle(text: "welcome back"), // Use the correct key
          const SizedBox(height: 8),
          AuthSubtitle(
              text: localizations
                  .signInSubtitle), // Use the correct key
          const SizedBox(height: 24),

          // EMAIL
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_emailOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: localizations.email, // Use the correct key
              controller: _emailController,
            ),
          ),
          const SizedBox(height: 16),

          // PASSWORD
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_passwordOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: localizations.password, // Use the correct key
              obscure: true,
              controller: _passwordController,
            ),
          ),
          const SizedBox(height: 16),

          // SIGN IN BUTTON
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_signInButtonOffset, 0.0, 0.0),
            child: PrimaryButton(
              text: localizations.signIn, // Use the correct key
              onPressed: signInViewModel.isLoading
                  ? null
                  : () async {
                      final success = await signInViewModel.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (success) {
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MonthsScreen()),
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(signInViewModel.errorMessage ??
                                  localizations.loginFailed)), // Use the correct key
                        );
                      }
                    },
            ),
          ),

          if (signInViewModel.isLoading) const CircularProgressIndicator(),
          if (signInViewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                signInViewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 16),

          Text(
            localizations.orSignInWith, // Use the correct key
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

