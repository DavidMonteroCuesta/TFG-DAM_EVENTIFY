import 'package:eventify/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:eventify/common/constants/app_routes.dart';
import 'package:flutter/material.dart';

const int kSignUpLogicTrimLength = 0;
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

  // Navega a la pantalla de inicio de sesión
  void goToSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.signIn);
  }
}
