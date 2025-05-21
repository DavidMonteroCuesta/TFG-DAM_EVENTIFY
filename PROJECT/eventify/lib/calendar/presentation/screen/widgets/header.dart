import 'package:eventify/calendar/presentation/screen/add_event_screen.dart';
import 'package:eventify/calendar/presentation/screen/search_events_screen.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';

class Header extends StatefulWidget {
  final Function(int year)? onYearChanged;
  final int currentYear; // Nuevo: Año actual pasado desde CalendarScreen

  const Header({
    super.key,
    this.onYearChanged,
    required this.currentYear, // Ahora es requerido
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late int _currentYear;

  @override
  void initState() {
    super.initState();
    // Inicializa _currentYear con el valor pasado por el widget
    _currentYear = widget.currentYear;
  }

  @override
  void didUpdateWidget(covariant Header oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el año pasado por el widget cambia, actualiza el estado interno
    if (widget.currentYear != oldWidget.currentYear) {
      setState(() {
        _currentYear = widget.currentYear;
      });
    }
  }

  void _goToPreviousYear() {
    setState(() {
      _currentYear--;
    });
    widget.onYearChanged?.call(_currentYear);
  }

  void _goToNextYear() {
    setState(() {
      _currentYear++;
    });
    widget.onYearChanged?.call(_currentYear);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _goToPreviousYear,
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
              ),
              IconButton(
                onPressed: _goToNextYear,
                icon: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ShiningTextAnimation(
                  text: '$_currentYear', // Muestra el año del estado interno
                  style: TextStyles.urbanistBody1,
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EventSearchScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.search, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AddEventScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}