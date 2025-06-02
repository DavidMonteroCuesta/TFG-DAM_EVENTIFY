import 'package:eventify/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:eventify/common/constants/app_routes.dart';
import 'package:flutter/material.dart';

class SignInLogic {
  final SignInViewModel signInViewModel;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  SignInLogic({
    required this.signInViewModel,
    required this.emailController,
    required this.passwordController,
  });

  Future<void> signIn(BuildContext context) async {
    await signInViewModel.signInWithFirebase(
      context,
      emailController.text.trim(),
      passwordController.text.trim(),
    );
  }

  void goToSignUp(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.signUp);
  }
}
