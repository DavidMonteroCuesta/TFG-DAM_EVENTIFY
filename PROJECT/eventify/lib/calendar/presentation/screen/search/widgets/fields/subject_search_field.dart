import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

// Widget de campo de búsqueda por asunto para eventos.
class SubjectSearchField extends StatelessWidget {
  static const double _paddingBottom = 16.0;
  static const double _borderRadius = 10.0;
  static const double _contentPaddingHorizontal = 16.0;
  static const double _contentPaddingVertical = 12.0;

  final TextEditingController controller;
  final void Function(String)? onChanged;
  final BuildContext contextForStrings;

  const SubjectSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    required this.contextForStrings,
  });

  @override
  Widget build(BuildContext context) {
    // Campo de texto para buscar por asunto en eventos.
    return Padding(
      padding: const EdgeInsets.only(bottom: _paddingBottom),
      child: TextFormField(
        controller: controller,
        style: TextStyles.plusJakartaSansBody1,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: AppStrings.searchFieldSubject(
            contextForStrings,
          ),
          labelStyle: TextStyles.plusJakartaSansSubtitle2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: _contentPaddingHorizontal,
            vertical: _contentPaddingVertical,
          ),
          filled: true,
        ),
      ),
    );
  }
}
