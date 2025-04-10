import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String type;
  final DateTime date;
  final String priority;
  final String description;

  const UpcomingEventCard({
    super.key,
    required this.title,
    required this.type,
    required this.date,
    required this.priority,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEE, MMM d, yyyy, HH:mm', 'en_US').format(date);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _truncateText(title, 25),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                type.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formattedDate,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Priority: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              Text(
                priority,
                style: const TextStyle(color: Colors.orangeAccent), // Puedes personalizar el color por prioridad
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _truncateText(description, 60), // Limitar la descripción
            style: const TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  // Función para truncar el texto y añadir "..." si es necesario
  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength - 3)}...';
    }
  }
}