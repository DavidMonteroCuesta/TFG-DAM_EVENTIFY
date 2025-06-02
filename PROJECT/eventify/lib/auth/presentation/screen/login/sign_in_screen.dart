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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String routeName = AppRoutes.signIn;

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

    return EventifyAuthLayout(
      leftFooterText: '',
      rightFooterText: '',
      onLeftFooterTap: null,
      onRightFooterTap: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTitle(text: AppStrings.signInWelcomeTitle(context)),
          const SizedBox(height: 8),
          AuthSubtitle(text: AppStrings.signInSubtitle(context)),
          const SizedBox(height: 24),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_emailOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: AppStrings.signInEmailHint(context),
              controller: _emailController,
              textStyle: TextStyles.plusJakartaSansBody1,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_passwordOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: AppStrings.signInPasswordHint(context),
              obscure: true,
              controller: _passwordController,
              textStyle: TextStyles.plusJakartaSansBody1,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_signInButtonOffset, 0.0, 0.0),
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
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
          if (signInViewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                signInViewModel.errorMessage!,
                style: TextStyles.plusJakartaSansBody1.copyWith(
                  color: AppColors.errorTextColor,
                ),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            height: 45,
            child: SocialSignInButton(
              icon: Image.asset(AppAssets.googleIcon, width: 24, height: 24),
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
          const SizedBox(height: 16),
          const ForgotPasswordOption(),
        ],
      ),
    );
  }
}
