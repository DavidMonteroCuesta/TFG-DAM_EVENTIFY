import 'package:eventify/auth/presentation/screen/sign_up_screen.dart';
import 'package:eventify/auth/presentation/screen/widgets/auth_subtitle.dart';
import 'package:eventify/auth/presentation/screen/widgets/auth_title.dart';
import 'package:eventify/auth/presentation/screen/widgets/custom_text_field.dart';
import 'package:eventify/auth/presentation/screen/widgets/login_auth_layout.dart';
import 'package:eventify/auth/presentation/screen/widgets/primary_button.dart';
import 'package:eventify/auth/presentation/screen/widgets/social_sign_in_buttons.dart';
import 'package:eventify/auth/presentation/screen/widgets/forgot_passwd_option.dart';
import 'package:eventify/auth/presentation/screen/animations/ani_left_to_right.dart';
import 'package:eventify/calendar/presentation/screen/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/sign_in_view_model.dart';

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
      leftFooterText: 'Create Account',
      rightFooterText: 'Log In',
      onLeftFooterTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SignUpScreen()),
        );
      },
      onRightFooterTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTitle(text: 'Welcome Back'),
          const SizedBox(height: 8),
          AuthSubtitle(
              text: 'Fill out the information below in order to access your account.'),
          const SizedBox(height: 24),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_emailOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: 'Email',
              controller: _emailController,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_passwordOffset, 0.0, 0.0),
            child: CustomTextField(
              hintText: 'Password',
              obscure: true,
              controller: _passwordController,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_signInButtonOffset, 0.0, 0.0),
            child: PrimaryButton(
              text: 'Sign In',
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
                              builder: (_) => const CalendarScreen()),
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(signInViewModel.errorMessage ?? 'Login failed')),
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

