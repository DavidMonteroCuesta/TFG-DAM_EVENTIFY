import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {

  static TextStyle get urbanistH6 => GoogleFonts.urbanist(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: Colors.white,
      );

  static TextStyle get urbanistBody1 => GoogleFonts.urbanist(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: const Color.fromARGB(255, 131, 131, 131),
      );

  static TextStyle get urbanistSubtitle1 => GoogleFonts.urbanist(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade300,
      );

  static TextStyle get plusJakartaSansBody2 => GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Colors.grey.shade500,
      );

  static TextStyle get plusJakartaSansSubtitle2 => GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.grey.shade500,
      );

    static TextStyle get plusJakartaSansBody1 => GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.white,
      );

  static TextStyle get plusJakartaSansButton => GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white,
      );
}