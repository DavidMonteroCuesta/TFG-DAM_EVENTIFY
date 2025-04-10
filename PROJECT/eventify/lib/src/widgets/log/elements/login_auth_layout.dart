import 'package:flutter/material.dart';

class EventifyAuthLayout extends StatelessWidget {
  final Widget child;                 // El contenido que cambiará (SignInBody o SignUpBody)
  final VoidCallback? onLeftFooterTap;
  final VoidCallback? onRightFooterTap;
  final String leftFooterText;
  final String rightFooterText;

  const EventifyAuthLayout({
    super.key,
    required this.child,
    required this.leftFooterText,
    required this.rightFooterText,
    this.onLeftFooterTap,
    this.onRightFooterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'EVENTIFY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Cuerpo variable (Sign In o Sign Up)
                  child,

                  const SizedBox(height: 24),

                  // Footer: Dos textos con onTap (Create Account / Log In)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onLeftFooterTap,
                        child: Text(
                          leftFooterText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: onRightFooterTap,
                        child: Text(
                          rightFooterText,
                          style: const TextStyle(
                            color: Color(0xFF90B77D),
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
