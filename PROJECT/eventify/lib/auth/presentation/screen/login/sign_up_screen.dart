// ignore_for_file: use_build_context_synchronously

import 'package:eventify/auth/presentation/screen/login/sign_in_screen.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/auth_subtitle.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/auth_title.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/custom_text_field.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/login_auth_layout.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/primary_button.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/social_sign_in_buttons.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/sign_up_view_model.dart';
import 'package:eventify/common/animations/ani_left_to_right.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

const double kSignUpScreenTitleSpacing = 8.0;
const double kSignUpScreenSubtitleSpacing = 24.0;
const double kSignUpScreenFieldSpacing = 16.0;
const int kSignUpScreenEmailAnimDelay = 200;
const int kSignUpScreenUsernameAnimDelay = 250;
const int kSignUpScreenPasswordAnimDelay = 300;
const int kSignUpScreenConfirmPasswordAnimDelay = 400;
const int kSignUpScreenButtonAnimDelay = 1;
const int kSignUpScreenAnimDurationMs = 300;
const double kSignUpScreenErrorPaddingTop = 8.0;
const double kSignUpScreenOrFontSize = 14.0;
const double kSignUpScreenZero = 0.0;

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

  double _emailOffset = kSignUpScreenZero;
  double _passwordOffset = kSignUpScreenZero;
  double _confirmPasswordOffset = kSignUpScreenZero;
  double _usernameOffset = kSignUpScreenZero;
  double _signUpButtonOffset = kSignUpScreenZero;

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
    animateElement(-screenWidth, kSignUpScreenEmailAnimDelay, (value) {
      setState(() {
        _emailOffset = value;
      });
    });
    animateElement(-screenWidth, kSignUpScreenUsernameAnimDelay, (value) {
      setState(() {
        _usernameOffset = value;
      });
    });
    animateElement(-screenWidth, kSignUpScreenPasswordAnimDelay, (value) {
      setState(() {
        _passwordOffset = value;
      });
    });
    animateElement(-screenWidth, kSignUpScreenConfirmPasswordAnimDelay, (
      value,
    ) {
      setState(() {
        _confirmPasswordOffset = value;
      });
    });
    animateElement(-screenWidth, kSignUpScreenButtonAnimDelay, (value) {
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
      onLeftFooterTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTitle(text: AppStrings.signUpCreateAccountTitle(context)),
          SizedBox(height: kSignUpScreenTitleSpacing),
          AuthSubtitle(text: AppStrings.signUpSubtitleText(context)),
          SizedBox(height: kSignUpScreenSubtitleSpacing),
          AnimatedContainer(
            duration: Duration(milliseconds: kSignUpScreenAnimDurationMs),
            transform: Matrix4.translationValues(
              _emailOffset,
              kSignUpScreenZero,
              kSignUpScreenZero,
            ),
            child: CustomTextField(
              hintText: AppStrings.signUpEmailHint(context),
              controller: _emailController,
              textStyle: const TextStyle(),
            ),
          ),
          SizedBox(height: kSignUpScreenFieldSpacing),
          AnimatedContainer(
            duration: Duration(milliseconds: kSignUpScreenAnimDurationMs),
            transform: Matrix4.translationValues(
              _usernameOffset,
              kSignUpScreenZero,
              kSignUpScreenZero,
            ),
            child: CustomTextField(
              hintText: AppStrings.signUpUsernameHint(context),
              controller: _usernameController,
              textStyle: const TextStyle(),
            ),
          ),
          SizedBox(height: kSignUpScreenFieldSpacing),
          AnimatedContainer(
            duration: Duration(milliseconds: kSignUpScreenAnimDurationMs),
            transform: Matrix4.translationValues(
              _passwordOffset,
              kSignUpScreenZero,
              kSignUpScreenZero,
            ),
            child: CustomTextField(
              hintText: AppStrings.signUpPasswordHint(context),
              obscure: true,
              controller: _passwordController,
              textStyle: const TextStyle(),
            ),
          ),
          SizedBox(height: kSignUpScreenFieldSpacing),
          AnimatedContainer(
            duration: Duration(milliseconds: kSignUpScreenAnimDurationMs),
            transform: Matrix4.translationValues(
              _confirmPasswordOffset,
              kSignUpScreenZero,
              kSignUpScreenZero,
            ),
            child: CustomTextField(
              hintText: AppStrings.signUpConfirmPasswordHint(context),
              obscure: true,
              controller: _confirmPasswordController,
              textStyle: const TextStyle(),
            ),
          ),
          SizedBox(height: kSignUpScreenFieldSpacing),
          AnimatedContainer(
            duration: Duration(milliseconds: kSignUpScreenAnimDurationMs),
            transform: Matrix4.translationValues(
              _signUpButtonOffset,
              kSignUpScreenZero,
              kSignUpScreenZero,
            ),
            child: PrimaryButton(
              text: AppStrings.signUpGetStartedButton(context),
              onPressed:
                  signUpViewModel.isLoading
                      ? null
                      : () async {
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          final success = await signUpViewModel.register(
                            _emailController.text,
                            _passwordController.text,
                            _usernameController.text,
                          );
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CalendarScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  signUpViewModel.errorMessage ??
                                      AppInternalConstants
                                          .signUpRegistrationFailedFallback,
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                AppInternalConstants.signUpPasswordsDoNotMatch,
                              ),
                            ),
                          );
                        }
                      },
            ),
          ),
          if (signUpViewModel.isLoading)
            CircularProgressIndicator(color: AppColors.primary),
          if (signUpViewModel.errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: kSignUpScreenErrorPaddingTop),
              child: Text(
                signUpViewModel.errorMessage!,
                style: const TextStyle(color: AppColors.errorTextColor),
              ),
            ),
          SizedBox(height: kSignUpScreenFieldSpacing),
          Text(
            AppStrings.signUpOrSignUpWith(context),
            style: TextStyle(
              color: AppColors.textGrey500,
              fontSize: kSignUpScreenOrFontSize,
            ),
          ),
          SizedBox(height: kSignUpScreenFieldSpacing),
          const SocialSignInButtons(),
        ],
      ),
    );
  }
}
