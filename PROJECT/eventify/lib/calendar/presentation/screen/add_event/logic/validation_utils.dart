import 'package:eventify/common/constants/app_internal_constants.dart';

String? validateTitle(String? value) {
  if (value == null || value.isEmpty) {
    return AppInternalConstants.addEventValidationTitle;
  }
  return null;
}

String? validateDescription(String? value) {
  if (value == null || value.isEmpty) {
    return AppInternalConstants.addEventValidationDescription;
  }
  return null;
}
