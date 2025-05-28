import 'package:flutter/material.dart';

class FooterLogic {
  static double getFooterHeight(
    BuildContext context, {
    double percentage = 0.12,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * percentage;
  }
}
