// ignore_for_file: deprecated_member_use

import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';

// Tarjeta visual para mostrar la información de un evento en los resultados de búsqueda
class EventResultCard extends StatelessWidget {
  final Event event;
  final String eventTypeString;
  final String formattedDateTime;
  final String Function(String) getTranslatedPriorityDisplay;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double width;
  final BuildContext contextForStrings;

  const EventResultCard({
    super.key,
    required this.event,
    required this.eventTypeString,
    required this.formattedDateTime,
    required this.getTranslatedPriorityDisplay,
    required this.onEdit,
    required this.onDelete,
    required this.width,
    required this.contextForStrings,
  });

  static const double _verticalPadding = 8.0;
  static const double _containerPadding = 12.0;
  static const double _borderRadius = 8.0;
  static const double _borderOpacity = 0.3;
  static const double _titleFontSize = 18.0;
  static const double _sizedBoxHeight = 4.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: SizedBox(
        width: width,
        child: Container(
          padding: const EdgeInsets.all(_containerPadding),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(
              color: AppColors.outlineColorLight.withOpacity(_borderOpacity),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: TextStyles.plusJakartaSansBody1.copyWith(
                        fontSize: _titleFontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      // Botón para editar el evento
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.editIconColor,
                        ),
                        onPressed: onEdit,
                      ),
                      // Botón para eliminar el evento
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.deleteIconColor,
                        ),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: _sizedBoxHeight),
              // Fecha y hora del evento
              Text(
                '${AppStrings.searchDateAndTimePrefix(contextForStrings)}$formattedDateTime',
                style: TextStyles.plusJakartaSansBody2,
              ),
              const SizedBox(height: _sizedBoxHeight),
              // Tipo de evento
              Text(
                '${AppStrings.searchTypePrefix(contextForStrings)}$eventTypeString',
                style: TextStyles.plusJakartaSansBody2,
              ),
              const SizedBox(height: _sizedBoxHeight),
              // Descripción del evento
              Text(
                '${AppStrings.searchDescriptionPrefix(contextForStrings)}${event.description ?? "-"}',
                style: TextStyles.plusJakartaSansBody2,
              ),
              // Prioridad del evento
              Text(
                '${AppStrings.searchPriorityPrefix(contextForStrings)}${getTranslatedPriorityDisplay(event.priority.toString().split('.').last)}',
                style: TextStyles.plusJakartaSansBody2.copyWith(
                  color: AppColors.priorityTextColorDynamic,
                ),
              ),
              // Localización si existe
              if (event.location != null && event.location!.isNotEmpty)
                Text(
                  '${AppStrings.searchLocationPrefix(contextForStrings)}${event.location}',
                  style: TextStyles.plusJakartaSansBody2,
                ),
              // Asignatura si existe
              if (event.subject != null && event.subject!.isNotEmpty)
                Text(
                  '${AppStrings.searchSubjectPrefix(contextForStrings)}${event.subject}',
                  style: TextStyles.plusJakartaSansBody2,
                ),
              // Persona asociada si existe
              if (event.withPerson != null && event.withPerson!.isNotEmpty)
                Text(
                  '${AppStrings.searchWithPersonPrefix(contextForStrings)}${event.withPerson}',
                  style: TextStyles.plusJakartaSansBody2,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
