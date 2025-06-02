// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class PriorityChipColorLogic {
  static Color getPriorityOptionBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary.withOpacity(0.15);
  }
}
