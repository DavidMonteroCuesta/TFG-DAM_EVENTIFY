// ignore_for_file: use_build_context_synchronously

import 'package:eventify/auth/presentation/screen/login/sign_in_screen.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const int _animationDurationMs = 2500;
  static const int _typewriterDelayMs = 90;
  static const int _eraseDelayMs = 300;
  static const double _fontSize = 50;
  static const double _letterSpacing = 2.5;

  late AnimationController _controller;
  String _typedText = '';
  static final String _fullText = AppInternalConstants.appName.toUpperCase();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _animationDurationMs),
    );

    _controller.forward().then((_) => _navigateToNext());
    _startTypewriter();
  }

  void _startTypewriter() async {
    // Escribir letra a letra
    for (int i = 1; i <= _fullText.length; i++) {
      await Future.delayed(Duration(milliseconds: _typewriterDelayMs));
      if (!mounted) return;
      setState(() {
        _typedText = _fullText.substring(0, i);
      });
    }
    // Espera breve antes de borrar
    await Future.delayed(Duration(milliseconds: _eraseDelayMs));
    // Borrar letra a letra
    for (int i = _fullText.length - 1; i >= 0; i--) {
      await Future.delayed(Duration(milliseconds: _typewriterDelayMs));
      if (!mounted) return;
      setState(() {
        _typedText = _fullText.substring(0, i);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    // Navega solo después de la animación, no inmediatamente
    Future.delayed(Duration.zero, () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CalendarScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          _typedText,
          style: GoogleFonts.permanentMarker(
            textStyle: TextStyle(
              color: AppColors.currentUserSelectedColor,
              fontSize: _fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: _letterSpacing,
            ),
          ),
        ),
      ),
    );
  }
}
