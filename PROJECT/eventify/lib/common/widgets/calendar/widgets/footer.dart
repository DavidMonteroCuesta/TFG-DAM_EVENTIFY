import 'package:eventify/common/widgets/calendar/widgets/buttons/calendar_toggle_button.dart';
import 'package:eventify/common/widgets/calendar/widgets/buttons/profile_button.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final VoidCallback onToggleCalendar;
  final bool isMonthlyView;
  final VoidCallback? onProfileTap; // Callback opcional para la acción del perfil

  const Footer({
    super.key,
    required this.onToggleCalendar,
    required this.isMonthlyView,
    this.onProfileTap, // Inicializa el callback del perfil
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final footerHeightPercentage = 0.08;
    final footerHeight = screenHeight * footerHeightPercentage;

    return Container(
      height: footerHeight,
      color: Colors.grey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.star_border, color: Colors.white, size: 24.0),
          const Icon(Icons.star_border, color: Colors.white, size: 24.0),
          CalendarToggleButton(
            onToggleCalendar: onToggleCalendar,
            isMonthlyView: isMonthlyView,
          ),
          ProfileButton( // Usa el ProfileButton aquí
            onPressed: onProfileTap, // Asigna el callback
            size: 24.0, // Ajusta el tamaño si es necesario
          ),
        ],
      ),
    );
  }
}