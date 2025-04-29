import 'package:eventify/auth/domain/presentation/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';

class LogoutService {
  static void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (Route<dynamic> route) => false,
    );
  }
}