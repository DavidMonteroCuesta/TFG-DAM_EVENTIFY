import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eventify/common/theme/colors/app_colors.dart'; // Nueva ruta de importación

abstract class TextStyles {

  static TextStyle get urbanistH6 => GoogleFonts.urbanist(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: AppColors.textPrimary, // Usando AppColors
      );

  static TextStyle get urbanistBody1 => GoogleFonts.urbanist(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: AppColors.textBody1Grey, // Usando AppColors
      );

  static TextStyle get urbanistSubtitle1 => GoogleFonts.urbanist(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textSubtitle1Grey, // Usando AppColors
      );

  static TextStyle get plusJakartaSansBody2 => GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.textBody2Grey, // Usando AppColors
      );

  static TextStyle get plusJakartaSansSubtitle2 => GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.textBody2Grey, // Usando AppColors
      );

    static TextStyle get plusJakartaSansBody1 => GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.textPrimary, // Usando AppColors
      );

  static TextStyle get plusJakartaSansButton => GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.textPrimary, // Usando AppColors
      );
}
