import 'package:flutter/material.dart';

class PriorityChipColorLogic {
  static Color getPriorityOptionBackgroundColor(BuildContext context) {
    // ignore: deprecated_member_use
    return Theme.of(context).colorScheme.secondary.withOpacity(0.15);
  }
}
