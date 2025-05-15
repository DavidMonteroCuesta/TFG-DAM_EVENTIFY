import 'package:flutter/material.dart';
 
abstract class SlideLeftToRightAnimationState<T extends StatefulWidget> extends State<T> {
  double get screenWidth => MediaQuery.of(context).size.width;

  void animateElement(double beginOffset, int delay, void Function(double) updateOffset) {
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        setState(() {
          updateOffset(0.0);
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