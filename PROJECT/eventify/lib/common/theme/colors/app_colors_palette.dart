import 'package:flutter/material.dart';

/// Clase abstracta interna que define la paleta de colores base de la aplicación.
/// Contiene las definiciones de Color crudas y únicas, evitando duplicaciones.
abstract class AppColorPalette {
  // Colores fundamentales de Flutter
  static const Color green = Colors.green;
  static const Color greenAccent = Colors.greenAccent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color blueAccent = Colors.blueAccent;
  static const Color red = Colors.red;
  static const Color redAccent = Colors.redAccent;
  static const Color yellow = Colors.yellow;
  static const Color orange = Colors.orange;
  static const Color orangeAccent = Colors.orangeAccent;
  static const Color blueGrey = Colors.blueGrey;

  // Colores con opacidad o valores específicos que no son directos de Colors.
  static const Color white70 = Colors.white70;
  static const Color white12 = Colors.white12;
  static const Color black87 = Colors.black87;
  static const Color black45 = Colors.black45; // Para sombras, etc.

  // Colores específicos con valores hexadecimales o RGB para mayor precisión
  static const Color color1F1F1F = Color(0xFF1F1F1F); // Usado para cardBackground, inputFillColor, inputBackground
  static const Color color262626 = Color(0xFF262626); // Usado para calendarBackground
  static const Color color212121 = Color(0xFF212121); // Usado para dialogBackground
  static const Color color1E1E1E = Color.fromARGB(255, 30, 30, 30); // Usado para profileHeaderBackground
  static const Color color2A2A2A = Color(0xFF2A2A2A); // Usado para dropdownContentBackground
  static const Color color757575 = Color(0xFF757575); // Usado para userMessageBubbleBackground, switchInactiveTrackColor
  static const Color color303030 = Color(0xFF303030); // Usado para footerBackground
  static const Color color838383 = Color.fromARGB(255, 131, 131, 131); // Usado para textBody1Grey
  static const Color colorE0E0E0 = Color(0xFFE0E0E0); // Usado para textSubtitle1Grey, outlineColorLight, authTitleColor
  static const Color color9E9E9E = Color(0xFF9E9E9E); // Usado para textBody2Grey, textGrey500
  static const Color colorBDBDBD = Color(0xFFBDBDBD); // Usado para textGrey400, choiceChipBorderColor, switchInactiveThumbColor
  static const Color colorE0F7FA = Color(0xFFE0F7FA); // Usado para primaryContainer
  static const Color color00E676 = Color(0xFF00E676); // Usado para accentColor400
  static const Color color69F0AE = Color.fromRGBO(105, 240, 174, 1); // Usado para focusedBorderGreen
  static const Color colorCBCBCB = Color(0xFFCBCBCB); // Usado para shineColorLight
  static const Color colorBDBDBD_0_2 = Color.fromRGBO(189, 189, 189, 0.2); // Usado para todayHighlightColor
  static const Color color9E9E9E_0_4 = Color.fromRGBO(158, 158, 158, 0.4); // Usado para highlightColorGrey
  static const Color colorFFFFFF_0_4 = Color.fromRGBO(255, 255, 255, 0.4); // Usado para highlightColorWhite
  static const Color color000000_0_8 = Color.fromRGBO(0, 0, 0, 0.8); // Usado para priorityOptionSelectedTextColor
  static const Color color0F0F0F = Color(0xFF0F0F0F); // Usado para priorityOptionBackground
  static const Color color90B77D = Color(0xFF90B77D); // Usado para footerRightTextColor
  static const Color color464646 = Color.fromARGB(255, 70, 70, 70); // Usado para profileMediumGrey
  static const Color color424242 = Color(0xFF424242); // Usado para headerBackground
}
