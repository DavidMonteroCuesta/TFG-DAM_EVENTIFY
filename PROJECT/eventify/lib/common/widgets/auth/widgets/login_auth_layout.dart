import 'package:eventify/common/widgets/auth/animations/ani_shining_text.dart';
import 'package:eventify/generated/l10n.dart';
import 'package:flutter/material.dart';

class EventifyAuthLayout extends StatelessWidget {
  final Widget child;
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
    final localizations = S.of(context); // Obtén la instancia de AppLocalizations

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
                  ShiningTextAnimation( // Envuelve el Text con ShiningTextAnimation
                    text: localizations.EVENTIFY,  // Usa la clave l10n
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    duration: const Duration(milliseconds: 2000), // Ajusta la duración del brillo
                    shineColor: Colors.greenAccent.shade400, // Ajusta el color del brillo
                  ),
                  const SizedBox(height: 32),
                  child,
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onLeftFooterTap,
                        child: Text(
                          leftFooterText, // Usa la variable, asumo que ya están l10n
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
                          rightFooterText, // Usa la variable, asumo que ya están l10n
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