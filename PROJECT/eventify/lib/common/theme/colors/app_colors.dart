// eventify/common/theme/colors/app_colors.dart
import 'package:eventify/common/theme/colors/app_colors_palette.dart';
import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación.
/// Cada color tiene un nombre descriptivo y referencia a la paleta base.
/// Esta clase actúa como la interfaz pública para acceder a los colores.
abstract class AppColors extends AppColorPalette {
  // --- USER-MANAGED DYNAMIC ACCENT COLOR SOURCE ---
  // This static nullable field will hold the user's selected color.
  // YOU MUST update this variable whenever the user changes their color preference.
  // WARNING: Changing this will NOT automatically trigger UI updates for widgets
  // using the dynamic color getters below.
  static Color? currentUserSelectedColor;

  // --- DYNAMIC COLOR GETTERS (Non-reactive, based on currentUserSelectedColor) ---
  // These getters provide dynamic colors. If currentUserSelectedColor is null,
  // they use their default fallback colors. If it's not null, they use currentUserSelectedColor.
  // You can call these as AppColors.primary, AppColors.secondary, etc.
  // REMEMBER: Widgets using these will NOT automatically rebuild when currentUserSelectedColor changes.

  // Primary Color (now dynamic)
  static Color get primary {
    return currentUserSelectedColor ?? AppColorPalette.green;
  }

  // Accent and Interactive Element Colors (made dynamic where requested)
  // notificationOrange (now strictly follows theme color if set)
  static Color get notificationOrange {
    // Si el usuario seleccionó un color, úsalo. De lo contrario, usa el naranja predeterminado.
    return currentUserSelectedColor ?? AppColorPalette.orange;
  }

  // deleteButtonColor (now strictly follows theme color if set)
  static Color get deleteButtonColor {
    // Si el usuario seleccionó un color, úsalo. De lo contrario, usa el rojo predeterminado.
    return currentUserSelectedColor ?? AppColorPalette.red;
  }

  static Color get priorityCriticalColor {
    return currentUserSelectedColor ?? AppColorPalette.red;
  }

  static Color get priorityHighColor {
    return currentUserSelectedColor ?? AppColorPalette.orange;
  }

  static Color get priorityMediumColor {
    return currentUserSelectedColor ?? AppColorPalette.yellow;
  }

  static Color get priorityLowColor {
    return currentUserSelectedColor ?? AppColorPalette.green;
  }

  static Color get priorityTextColorDynamic {
    return currentUserSelectedColor ?? AppColorPalette.orangeAccent;
  }

  static Color get calendarAccentColor {
    return currentUserSelectedColor ?? AppColorPalette.orangeAccent;
  }

  static Color get secondaryDynamic {
    return currentUserSelectedColor ?? AppColorPalette.greenAccent;
  }

  static Color get focusedBorderDynamic {
    return currentUserSelectedColor ?? AppColorPalette.color69F0AE;
  }

  static Color get onSecondaryDynamic {
    return secondaryDynamic.computeLuminance() > 0.5 ? AppColorPalette.black : AppColorPalette.white;
  }

  static Color get outlineDynamic {
    return secondaryDynamic.withOpacity(0.5);
  }

  static Color get outlinedButtonBorderDynamic {
    return secondaryDynamic;
  }

  static Color get textSecondaryDynamic {
    return secondaryDynamic;
  }


  // --- STATIC CONSTANT COLORS (FIXED - DO NOT CHANGE AT RUNTIME) ---
  // These colors are always the same regardless of user selection.

  // Background Colors
  static const Color background = AppColorPalette.black;
  static const Color cardBackground = AppColorPalette.color1F1F1F;
  static const Color calendarBackground = AppColorPalette.color262626;
  static const Color dialogBackground = AppColorPalette.color212121;
  static const Color profileHeaderBackground = AppColorPalette.color1E1E1E;
  static const Color dropdownContentBackground = AppColorPalette.color2A2A2A;
  static const Color userMessageBubbleBackground = AppColorPalette.color757575;
  static const Color chatButtonBackground = AppColorPalette.white12;
  static const Color footerBackground = AppColorPalette.color303030;
  static const Color inputFillColor = AppColorPalette.white12;
  static const Color headerBackground = AppColorPalette.color424242;


  // Text Colors
  static const Color textPrimary = AppColorPalette.white;
  static const Color textSecondary = AppColorPalette.grey; // Keep this as a general static grey
  static const Color avatarTextColor = AppColorPalette.white;
  static const Color hintTextColor = AppColorPalette.grey;
  static const Color textOnLightBackground = AppColorPalette.black;
  static const Color textBody1Grey = AppColorPalette.color838383;
  static const Color textSubtitle1Grey = AppColorPalette.colorE0E0E0;
  static const Color textBody2Grey = AppColorPalette.color9E9E9E;
  static const Color textGrey400 = AppColorPalette.colorBDBDBD;
  static const Color textGrey500 = AppColorPalette.color9E9E9E;
  static const Color authTitleColor = AppColorPalette.colorE0E0E0;


  // Border and Line Colors
  static const Color dividerColor = AppColorPalette.grey;
  static const Color outline = AppColorPalette.grey;
  static const Color outlinedButtonBorder = AppColorPalette.grey; // Keep this as a general static grey
  static const Color outlineColorLight = AppColorPalette.colorE0E0E0;
  static const Color choiceChipBorderColor = AppColorPalette.colorBDBDBD;


  // Accent and Interactive Element Colors (Keep these static if they are not tied to currentUserSelectedColor)
  static const Color primaryContainer = AppColorPalette.colorE0F7FA;
  static const Color onPrimaryContainer = AppColorPalette.black87;
  static const Color onSecondary = AppColorPalette.white; // Keep this static if it's always white/black
  static const Color accentColor400 = AppColorPalette.color00E676;
  static const Color editIconColor = AppColorPalette.blueAccent;
  static const Color snackBarInfoColor = AppColorPalette.blueGrey;


  // State and Feedback Colors
  static const Color errorTextColor = AppColorPalette.red;
  static const Color todayHighlightColor = AppColorPalette.colorBDBDBD_0_2;
  static const Color deleteIconColor = AppColorPalette.redAccent;
  static const Color checkboxCheckColor = AppColorPalette.black;


  // Shine and Effect Colors
  static const Color shineEffectColor = AppColorPalette.white70;
  static const Color shineColorLight = AppColorPalette.colorCBCBCB;
  static const Color highlightColorGrey = AppColorPalette.color9E9E9E_0_4;
  static const Color highlightColorWhite = AppColorPalette.colorFFFFFF_0_4;


  // Specific Component Colors
  static const Color switchInactiveTrackColor = AppColorPalette.color757575;
  static const Color switchInactiveThumbColor = AppColorPalette.colorBDBDBD;
  static const Color priorityOptionBackground = AppColorPalette.color0F0F0F;
  static const Color priorityOptionSelectedTextColor = AppColorPalette.color000000_0_8;
  static const Color fabIconColor = AppColorPalette.white;
  static const Color elevatedButtonForeground = AppColorPalette.black;
  static const Color footerIconColor = AppColorPalette.white;
  static const Color profileMediumGrey = AppColorPalette.color464646;
  static const Color footerRightTextColor = AppColorPalette.color90B77D;
  static const Color botMessageBackground = AppColorPalette.grey;
  static const Color avatarBotBackground = AppColorPalette.grey;
}