import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart'; // Assuming this import

class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String type;
  final DateTime date;
  final String priority;
  final String description;
  final VoidCallback? onEdit;
  final VoidCallback? onTapCard; // Nuevo: Callback para tocar la tarjeta completa

  const UpcomingEventCard({
    super.key,
    required this.title,
    required this.type,
    required this.date,
    required this.priority,
    required this.description,
    this.onEdit,
    this.onTapCard, // Inicializar el nuevo callback
  });

  @override
  Widget build(BuildContext context) {
    const Color outlineColor = Color(0xFFE0E0E0);

    return InkWell( // Envuelve la tarjeta con InkWell para que sea clicable
      onTap: onTapCard, // Asigna el callback onTapCard
      borderRadius: BorderRadius.circular(12.0), // Asegura que el InkWell tenga bordes redondeados
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: outlineColor.withOpacity(0.3),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.plusJakartaSansBody1.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // MODIFIED: Moved event type here to be at the top right
                Text(
                  type.split('.').last.toUpperCase(), // Format type string
                  style: TextStyles.plusJakartaSansBody2.copyWith(color: Colors.grey[400]),
                ),
              ],
            ),
            const SizedBox(height: 8.0), // Espacio consistente

            Text(
              'Date: ${DateFormat('yyyy/MM/dd HH:mm').format(date)}',
              style: TextStyles.plusJakartaSansBody2.copyWith(color: Colors.grey[400]),
            ),
            const SizedBox(height: 8.0), // Espacio consistente

            // REMOVED: Original position of Event Type
            // Text(
            //   'Type: ${type.split('.').last.toUpperCase()}',
            //   style: TextStyles.plusJakartaSansBody2.copyWith(color: Colors.grey[400]),
            // ),
            // const SizedBox(height: 8.0), // Espacio consistente

            Text(
              'Priority: ${priority.split('.').last.toUpperCase()}',
              style: TextStyles.plusJakartaSansBody2.copyWith(color: Colors.yellow),
            ),
            const SizedBox(height: 8.0), // Espacio consistente

            Flexible(
              child: Text(
                'Description: ${description.isNotEmpty ? description : 'Nothing'}',
                style: TextStyles.plusJakartaSansBody2.copyWith(color: Colors.grey[300]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
