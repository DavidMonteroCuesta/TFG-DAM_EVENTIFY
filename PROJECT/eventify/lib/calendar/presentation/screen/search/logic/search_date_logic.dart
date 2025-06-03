import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class SearchDateLogic {
  static const int _firstYear = 2023;
  static const int _lastYear = 2100;

  static Future<DateTime?> selectSearchDate({
    required BuildContext context,
    required DateTime? initialDate,
  }) async {
    // Muestra el selector de fecha con límites definidos y tema personalizado.
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(_firstYear),
      lastDate: DateTime(_lastYear),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: AppColors.primaryContainer,
            hintColor: AppColors.secondaryDynamic,
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryContainer,
            ).copyWith(secondary: AppColors.secondaryDynamic),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static void clearSearchDate({required void Function() onClear}) {
    // Limpia la fecha seleccionada.
    onClear();
  }
}
