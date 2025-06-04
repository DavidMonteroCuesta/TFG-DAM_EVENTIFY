import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors_palette.dart';
import 'package:eventify/common/constants/app_strings.dart';

// Constantes para la lógica de temas de perfil
const int kProfileThemeColorsCount = 5;

class ProfileThemeLogic {
  static final List<Color?> availableColors = [
    null,
    AppColorPalette.greenAccent,
    AppColorPalette.blueAccent,
    AppColorPalette.orangeAccent,
    AppColorPalette.redAccent,
  ];

  // Devuelve los nombres de los colores disponibles para el perfil
  static List<String> colorNames(BuildContext context) => [
    AppStrings.profileThemeDefault(context),
    AppStrings.profileThemeGreen(context),
    AppStrings.profileThemeBlue(context),
    AppStrings.profileThemeOrange(context),
    AppStrings.profileThemeRed(context),
  ];

  // Busca el color seleccionado en el dropdown según el color actual del tema
  static Color? getMatchedDropdownValue(Color? currentAppThemeColor) {
    for (int i = 0; i < availableColors.length; i++) {
      Color? optionColor = availableColors[i];
      if (optionColor == null) {
        if (currentAppThemeColor == AppColorPalette.greenAccent) {
          return null;
        }
      } else {
        if (optionColor == currentAppThemeColor) {
          return optionColor;
        }
      }
    }
    return null;
  }
}
