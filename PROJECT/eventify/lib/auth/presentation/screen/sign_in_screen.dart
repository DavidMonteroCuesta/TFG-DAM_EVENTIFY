import 'package:eventify/auth/presentation/screen/sign_up_screen.dart';
import 'package:eventify/auth/presentation/screen/widgets/auth_subtitle.dart';
import 'package:eventify/auth/presentation/screen/widgets/auth_title.dart';
import 'package:eventify/auth/presentation/screen/widgets/custom_text_field.dart';
import 'package:eventify/auth/presentation/screen/widgets/login_auth_layout.dart';
import 'package:eventify/auth/presentation/screen/widgets/primary_button.dart';
import 'package:eventify/auth/presentation/screen/widgets/social_sign_in_buttons.dart';
import 'package:eventify/auth/presentation/screen/widgets/forgot_passwd_option.dart';
import 'package:eventify/common/animations/ani_left_to_right.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/sign_in_view_model.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/colors.dart'; // Import AppColors

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String routeName = '/signin';

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
      leftFooterText: AppStrings.signInCreateAccountText(context),
      rightFooterText: AppStrings.signInLogInText(context),
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
          AuthTitle(text: AppStrings.signInWelcomeTitle(context)),
          const SizedBox(height: 8),
          AuthSubtitle(
              text: AppStrings.signInSubtitle(context)),
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
              onPressed: signInViewModel.isLoading
                  ? null
                  : () async {
                      await signInViewModel.signInWithFirebase(
                          context, _emailController.text.trim(), _passwordController.text.trim());
                    },
            ),
          ),
          if (signInViewModel.isLoading) CircularProgressIndicator(color: AppColors.primary), // Using AppColors
          if (signInViewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                signInViewModel.errorMessage!,
                style: TextStyles.plusJakartaSansBody1.copyWith(color: AppColors.errorTextColor), // Using AppColors
              ),
            ),
          const SizedBox(height: 16),
          Text(
            AppStrings.signInOrSignInWith(context),
            style: TextStyles.plusJakartaSansBody2.copyWith(color: AppColors.textGrey500), // Using AppColors
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
