import 'package:flutter/material.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

class WithPersonField extends StatelessWidget {
  final bool withPersonYesNoSearch;
  final ValueChanged<bool?> onChanged;
  final TextEditingController controller;
  final String labelText;
  final String yesNoLabel;

  const WithPersonField({
    super.key,
    required this.withPersonYesNoSearch,
    required this.onChanged,
    required this.controller,
    required this.labelText,
    required this.yesNoLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                yesNoLabel,
                style: TextStyles.plusJakartaSansBody1.copyWith(
                  fontSize: 16.0,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8.0),
              Checkbox(
                value: withPersonYesNoSearch,
                onChanged: onChanged,
                activeColor: AppColors.focusedBorderDynamic,
                checkColor: AppColors.checkboxCheckColor,
              ),
            ],
          ),
          Visibility(
            visible: withPersonYesNoSearch,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: controller,
                style: TextStyles.plusJakartaSansBody1,
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: TextStyles.plusJakartaSansSubtitle2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: AppColors.focusedBorderDynamic,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  filled: true,
                  fillColor: AppColors.inputFillColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
