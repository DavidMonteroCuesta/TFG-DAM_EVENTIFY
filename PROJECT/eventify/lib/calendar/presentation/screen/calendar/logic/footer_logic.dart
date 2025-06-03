import 'package:flutter/material.dart';

// Lógica para calcular la altura del pie de página del calendario según el tamaño de pantalla.
class FooterLogic {
  static const double _defaultFooterPercentage = 0.12;

  // Devuelve la altura del footer como un porcentaje de la altura de pantalla.
  static double getFooterHeight(
    BuildContext context, {
    double percentage = _defaultFooterPercentage,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * percentage;
  }
}
