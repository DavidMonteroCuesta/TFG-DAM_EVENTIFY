import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class ShiningTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Color shineColor;

  const ShiningTextAnimation({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 9999),
    this.shineColor = AppColors.shineEffectColor, 
  });

  @override
  State<ShiningTextAnimation> createState() => _ShiningTextAnimationState();
}

class _ShiningTextAnimationState extends State<ShiningTextAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _maskAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true); // Cambiando a false va pero no vuelve
    _maskAnimation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
                    Colors.transparent, // Colors.transparent es una constante de Flutter, no necesita AppColors
                    widget.shineColor.withOpacity(0.8),
                    widget.shineColor.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  stops: [
                    _maskAnimation.value * 0.5 + 0.2,
                    _maskAnimation.value * 0.5 + 0.5,
                    _maskAnimation.value * 0.5 + 0.6,
                    _maskAnimation.value * 0.5 + 0.8,
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
