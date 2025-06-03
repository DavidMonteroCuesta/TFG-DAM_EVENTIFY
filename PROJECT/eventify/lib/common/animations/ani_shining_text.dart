// ignore_for_file: deprecated_member_use

import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

// Widget animado que muestra un texto con efecto de brillo animado
class ShiningTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Color shineColor;

  static const int _defaultDurationMs = 9999;
  static const double _maskBegin = -1.5;
  static const double _maskEnd = 1.5;
  static const double _stop1 = 0.2;
  static const double _stop2 = 0.5;
  static const double _stop3 = 0.6;
  static const double _stop4 = 0.8;

  const ShiningTextAnimation({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: _defaultDurationMs),
    this.shineColor = AppColors.shineEffectColor,
  });

  @override
  State<ShiningTextAnimation> createState() => _ShiningTextAnimationState();
}

class _ShiningTextAnimationState extends State<ShiningTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _maskAnimation;

  static const double _shaderMaskBlendOpacity = 0.8;
  static const double _shaderMaskTransparent = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(
      reverse: true,
    ); // Controla la animación de brillo, en caso de ser false la animación se ejecutará una sola vez.
    _maskAnimation = Tween<double>(
      begin: ShiningTextAnimation._maskBegin,
      end: ShiningTextAnimation._maskEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(widget.text, style: widget.style),
        AnimatedBuilder(
          animation: _maskAnimation,
          builder: (context, child) {
            return ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent.withOpacity(_shaderMaskTransparent),
                    widget.shineColor.withOpacity(_shaderMaskBlendOpacity),
                    widget.shineColor.withOpacity(_shaderMaskBlendOpacity),
                    Colors.transparent.withOpacity(_shaderMaskTransparent),
                  ],
                  stops: [
                    _maskAnimation.value * 0.5 + ShiningTextAnimation._stop1,
                    _maskAnimation.value * 0.5 + ShiningTextAnimation._stop2,
                    _maskAnimation.value * 0.5 + ShiningTextAnimation._stop3,
                    _maskAnimation.value * 0.5 + ShiningTextAnimation._stop4,
                  ],
                ).createShader(bounds);
              },
              child: Text(widget.text, style: widget.style),
            );
          },
        ),
      ],
    );
  }
}
