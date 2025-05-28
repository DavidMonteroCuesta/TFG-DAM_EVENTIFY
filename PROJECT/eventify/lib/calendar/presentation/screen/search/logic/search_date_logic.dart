import 'package:flutter/material.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

class SearchDateLogic {
  static Future<DateTime?> selectSearchDate({
    required BuildContext context,
    required DateTime? initialDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
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
    onClear();
  }
}
