import 'package:flutter/material.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';

class DescriptionSearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final BuildContext contextForStrings;

  const DescriptionSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    required this.contextForStrings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        style: TextStyles.plusJakartaSansBody1,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: AppStrings.searchFieldDescription(contextForStrings),
          labelStyle: TextStyles.plusJakartaSansSubtitle2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          filled: true,
        ),
      ),
    );
  }
}
