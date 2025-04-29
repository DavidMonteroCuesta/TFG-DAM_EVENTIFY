import 'package:eventify/auth/domain/presentation/screen/sign_in_screen.dart';
import 'package:eventify/auth/domain/presentation/screen/widgets/auth_subtitle.dart';
import 'package:eventify/auth/domain/presentation/screen/widgets/auth_title.dart';
import 'package:eventify/auth/domain/presentation/screen/widgets/custom_text_field.dart';
import 'package:eventify/auth/domain/presentation/screen/widgets/login_auth_layout.dart';
import 'package:eventify/auth/domain/presentation/screen/widgets/primary_button.dart';
import 'package:eventify/auth/domain/presentation/screen/widgets/social_sign_in_buttons.dart';
import 'package:eventify/common/widgets/calendar/widgets/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/sign_up_view_model.dart';
import 'package:eventify/auth/domain/presentation/screen/animations/ani_left_to_right.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends SlideLeftToRightAnimationState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController(); // Nuevo controlador para el nombre de usuario

  double _emailOffset = 0.0;
  double _passwordOffset = 0.0;
  double _confirmPasswordOffset = 0.0;
  double _usernameOffset = 0.0; // Nuevo offset para el nombre de usuario
  double _signUpButtonOffset = 0.0;

  @override
  void initializeAnimationOffsets() {
    _emailOffset = -screenWidth;
    _passwordOffset = -screenWidth;
    _confirmPasswordOffset = -screenWidth;
    _usernameOffset = -screenWidth; // Inicializar el offset del nombre de usuario
    _signUpButtonOffset = -screenWidth;
  }

  @override
  void startAnimations() {
    animateElement(-screenWidth, 200, (value) {
      setState(() {
        _emailOffset = value;
      });
    });
    animateElement(-screenWidth, 250, (value) { // Animar el campo del nombre de usuario
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
            child: CustomTextField(hintText: 'Email', controller: _emailController),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_usernameOffset, 0.0, 0.0), // Campo para el nombre de usuario
            child: CustomTextField(hintText: 'Username', controller: _usernameController),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_passwordOffset, 0.0, 0.0),
            child: CustomTextField(hintText: 'Password', obscure: true, controller: _passwordController),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_confirmPasswordOffset, 0.0, 0.0),
            child: CustomTextField(hintText: 'Confirm Password', obscure: true, controller: _confirmPasswordController),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_signUpButtonOffset, 0.0, 0.0),
            child: PrimaryButton(
              text: 'Get Started',
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
                            SnackBar(content: Text(signUpViewModel.errorMessage ?? 'Registration failed')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Passwords do not match')),
                        );
                      }
                    },
            ),
          ),
          if (signUpViewModel.isLoading) const CircularProgressIndicator(),
          if (signUpViewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                signUpViewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
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