// ignore_for_file: use_build_context_synchronously

import 'package:eventify/auth/presentation/screen/login/widgets/auth_subtitle.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/auth_title.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/custom_text_field.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/forgot_passwd_option.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/login_auth_layout.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/primary_button.dart';
import 'package:eventify/auth/presentation/screen/login/widgets/social_sign_in_button.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:eventify/common/animations/ani_left_to_right.dart';
import 'package:eventify/common/constants/app_assets.dart';
import 'package:eventify/common/constants/app_routes.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/sign_in_view_model.dart';

const double kSignInScreenTitleSpacing = 8.0;
const double kSignInScreenSubtitleSpacing = 24.0;
const double kSignInScreenFieldSpacing = 16.0;
const double kSignInScreenSocialButtonHeight = 45.0;
const double kSignInScreenErrorPaddingTop = 8.0;
const int kSignInScreenEmailAnimDelay = 200;
const int kSignInScreenPasswordAnimDelay = 300;
const int kSignInScreenButtonAnimDelay = 1;
const int kSignInScreenAnimDurationMs = 300;
const double kSignInScreenSocialIconSize = 24.0;
const double kSignInScreenZero = 0.0;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String routeName = AppRoutes.signIn;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends SlideLeftToRightAnimationState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  double _emailOffset = kSignInScreenZero;
  double _passwordOffset = kSignInScreenZero;
  double _signInButtonOffset = kSignInScreenZero;

  @override
  void initializeAnimationOffsets() {
    _emailOffset = -screenWidth;
    _passwordOffset = -screenWidth;
    _signInButtonOffset = -screenWidth;
  }

  @override
  void startAnimations() {
    animateElement(-screenWidth, kSignInScreenEmailAnimDelay, (value) {
      setState(() {
        _emailOffset = value;
      });
    });
    animateElement(-screenWidth, kSignInScreenPasswordAnimDelay, (value) {
      setState(() {
        _passwordOffset = value;
      });
    });
    animateElement(-screenWidth, kSignInScreenButtonAnimDelay, (value) {
      setState(() {
        _signInButtonOffset = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final signInViewModel = Provider.of<SignInViewModel>(context);

    return EventifyAuthLayout(
      leftFooterText: '',
      rightFooterText: '',
      onLeftFooterTap: null,
      onRightFooterTap: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTitle(text: AppStrings.signInWelcomeTitle(context)),
          SizedBox(height: kSignInScreenTitleSpacing),
          AuthSubtitle(text: AppStrings.signInSubtitle(context)),
          SizedBox(height: kSignInScreenSubtitleSpacing),
          AnimatedContainer(
            duration: Duration(milliseconds: kSignInScreenAnimDurationMs),
            transform: Matrix4.translationValues(
              _emailOffset,
              kSignInScreenZero,
              kSignInScreenZero,
            ),
            child: CustomTextField(
              hintText: AppStrings.signInEmailHint(context),
              controller: _emailController,
              textStyle: TextStyles.plusJakartaSansBody1,
            ),
          ),
          SizedBox(height: kSignInScreenFieldSpacing),
          AnimatedContainer(
            duration: Duration(milliseconds: kSignInScreenAnimDurationMs),
            transform: Matrix4.translationValues(
              _passwordOffset,
              kSignInScreenZero,
              kSignInScreenZero,
            ),
            child: CustomTextField(
              hintText: AppStrings.signInPasswordHint(context),
              obscure: true,
              controller: _passwordController,
              textStyle: TextStyles.plusJakartaSansBody1,
            ),
          ),
          SizedBox(height: kSignInScreenFieldSpacing),
          AnimatedContainer(
            duration: Duration(milliseconds: kSignInScreenAnimDurationMs),
            transform: Matrix4.translationValues(
              _signInButtonOffset,
              kSignInScreenZero,
              kSignInScreenZero,
            ),
            child: PrimaryButton(
              text: AppStrings.signInButtonText(context),
              onPressed:
                  signInViewModel.isLoading
                      ? null
                      : () async {
                        await signInViewModel.signInWithFirebase(
                          context,
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      },
            ),
          ),
          if (signInViewModel.isLoading)
            CircularProgressIndicator(color: AppColors.primary),
          if (signInViewModel.errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: kSignInScreenErrorPaddingTop),
              child: Text(
                signInViewModel.errorMessage!,
                style: TextStyles.plusJakartaSansBody1.copyWith(
                  color: AppColors.errorTextColor,
                ),
              ),
            ),
          SizedBox(height: kSignInScreenFieldSpacing),
          SizedBox(
            height: kSignInScreenSocialButtonHeight,
            child: SocialSignInButton(
              icon: Image.asset(
                AppAssets.googleIcon,
                width: kSignInScreenSocialIconSize,
                height: kSignInScreenSocialIconSize,
              ),
              text: AppStrings.socialSignInGoogleText(context),
              onPressed:
                  signInViewModel.isLoading
                      ? null
                      : () async {
                        final user = await signInViewModel
                            .signInWithGoogleAndPassword(context);
                        if (user != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const CalendarScreen(),
                              settings: RouteSettings(name: AppRoutes.calendar),
                            ),
                          );
                        }
                      },
            ),
          ),
          SizedBox(height: kSignInScreenFieldSpacing),
          const ForgotPasswordOption(),
        ],
      ),
    );
  }
}
