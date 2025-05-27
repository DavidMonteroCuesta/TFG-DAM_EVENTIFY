import 'package:eventify/auth/presentation/screen/sign_in_screen.dart';
import 'package:eventify/auth/presentation/screen/widgets/auth_subtitle.dart';
import 'package:eventify/auth/presentation/screen/widgets/auth_title.dart';
import 'package:eventify/auth/presentation/screen/widgets/custom_text_field.dart';
import 'package:eventify/auth/presentation/screen/widgets/login_auth_layout.dart';
import 'package:eventify/auth/presentation/screen/widgets/primary_button.dart';
import 'package:eventify/auth/presentation/screen/widgets/social_sign_in_buttons.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/sign_up_view_model.dart';
import 'package:eventify/common/animations/ani_left_to_right.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Import AppColors

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends SlideLeftToRightAnimationState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  double _emailOffset = 0.0;
  double _passwordOffset = 0.0;
  double _confirmPasswordOffset = 0.0;
  double _usernameOffset = 0.0;
  double _signUpButtonOffset = 0.0;

  @override
  void initializeAnimationOffsets() {
    _emailOffset = -screenWidth;
    _passwordOffset = -screenWidth;
    _confirmPasswordOffset = -screenWidth;
    _usernameOffset = -screenWidth;
    _signUpButtonOffset = -screenWidth;
  }

  @override
  void startAnimations() {
    animateElement(-screenWidth, 200, (value) {
      setState(() {
        _emailOffset = value;
      });
    });
    animateElement(-screenWidth, 250, (value) {
      setState(() {
        _usernameOffset = value;
      });
    });
    animateElement(-screenWidth, 300, (value) {
      setState(() {
        _passwordOffset = value;
      });
    });
    animateElement(-screenWidth, 400, (value) {
      setState(() {
        _confirmPasswordOffset = value;
      });
    });
    animateElement(-screenWidth, 1, (value) {
      setState(() {
        _signUpButtonOffset = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final signUpViewModel = Provider.of<SignUpViewModel>(context);

    return EventifyAuthLayout(
      leftFooterText: AppStrings.signUpCreateAccountTitle(context),
      rightFooterText: AppStrings.signUpLogInText(context),
      onRightFooterTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      },
      onLeftFooterTap: () {
        // Optional
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTitle(text: AppStrings.signUpCreateAccountTitle(context)),
          const SizedBox(height: 8),
          AuthSubtitle(text: AppStrings.signUpSubtitleText(context)),
          const SizedBox(height: 24),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_emailOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: AppStrings.signUpEmailHint(context),
              controller: _emailController,
              textStyle: const TextStyle(),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_usernameOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: AppStrings.signUpUsernameHint(context),
              controller: _usernameController,
              textStyle: const TextStyle(),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_passwordOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: AppStrings.signUpPasswordHint(context),
              obscure: true,
              controller: _passwordController,
              textStyle: const TextStyle(),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_confirmPasswordOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: AppStrings.signUpConfirmPasswordHint(context),
              obscure: true,
              controller: _confirmPasswordController,
              textStyle: const TextStyle(),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_signUpButtonOffset, 0.0, 0.0),
            child: PrimaryButton(
              text: AppStrings.signUpGetStartedButton(context),
              onPressed: signUpViewModel.isLoading
                  ? null
                  : () async {
                      if (_passwordController.text == _confirmPasswordController.text) {
                        final success = await signUpViewModel.register(
                          _emailController.text,
                          _passwordController.text,
                          _usernameController.text,
                        );
                        if (success) {
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(builder: (_) => const CalendarScreen()),
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(signUpViewModel.errorMessage ?? AppInternalConstants.signUpRegistrationFailedFallback)),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(AppInternalConstants.signUpPasswordsDoNotMatch)),
                        );
                      }
                    },
            ),
          ),
          if (signUpViewModel.isLoading) CircularProgressIndicator(color: AppColors.primary), // Using AppColors
          if (signUpViewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                signUpViewModel.errorMessage!,
                style: const TextStyle(color: AppColors.errorTextColor), // Using AppColors
              ),
            ),
          const SizedBox(height: 16),
          Text(
            AppStrings.signUpOrSignUpWith(context),
            style: TextStyle(
              color: AppColors.textGrey500, // Using AppColors
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
