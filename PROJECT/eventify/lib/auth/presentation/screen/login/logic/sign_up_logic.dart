import 'package:eventify/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';

class SignUpLogic {
  final SignUpViewModel signUpViewModel;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  SignUpLogic({
    required this.signUpViewModel,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  Future<void> signUp(BuildContext context, String username) async {
    await signUpViewModel.signUp(
      emailController.text.trim(),
      passwordController.text.trim(),
      username.trim(),
    );
  }

  void goToSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/signin');
  }
}
