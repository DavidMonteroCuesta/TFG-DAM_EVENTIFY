import 'package:eventify/common/constants/app_internal_constants.dart';

// Valida el título del evento. Devuelve un mensaje si está vacío o nulo.
String? validateTitle(String? value) {
  if (value == null || value.isEmpty) {
    return AppInternalConstants.addEventValidationTitle;
  }
  return null;
}

// Valida la descripción del evento. Devuelve un mensaje si está vacía o nula.
String? validateDescription(String? value) {
  if (value == null || value.isEmpty) {
    return AppInternalConstants.addEventValidationDescription;
  }
  return null;
}
