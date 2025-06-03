import 'package:flutter/material.dart';

// Clase base para animaciones de deslizamiento de izquierda a derecha en widgets con estado
abstract class SlideLeftToRightAnimationState<T extends StatefulWidget>
    extends State<T> {
  static const int defaultDelayMs = 0;
  static const double _offsetEnd = 0.0;

  double get screenWidth => MediaQuery.of(context).size.width;

  void animateElement(
    double beginOffset,
    int delay,
    void Function(double) updateOffset,
  ) {
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        setState(() {
          updateOffset(_offsetEnd);
        });
      }
    });
  }

  void initializeAnimationOffsets();
  void startAnimations();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeAnimationOffsets();
      startAnimations();
    });
  }
}
