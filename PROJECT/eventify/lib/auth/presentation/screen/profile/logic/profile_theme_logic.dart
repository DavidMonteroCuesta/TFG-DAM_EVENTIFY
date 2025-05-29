import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors_palette.dart';
import 'package:eventify/common/constants/app_strings.dart';

class ProfileThemeLogic {
  static final List<Color?> availableColors = [
    null,
    AppColorPalette.greenAccent,
    AppColorPalette.blueAccent,
    AppColorPalette.orangeAccent,
    AppColorPalette.redAccent,
  ];

  static List<String> colorNames(BuildContext context) => [
    AppStrings.profileThemeDefault(context),
    AppStrings.profileThemeGreen(context),
    AppStrings.profileThemeBlue(context),
    AppStrings.profileThemeOrange(context),
    AppStrings.profileThemeRed(context),
  ];

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
