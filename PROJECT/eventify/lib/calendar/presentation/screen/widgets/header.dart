import 'package:eventify/calendar/presentation/screen/add_event_screen.dart';
import 'package:eventify/calendar/presentation/screen/search_events_screen.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';

class Header extends StatefulWidget {
  final Function(int year)? onYearChanged; // Nuevo: Callback para cuando el año cambia

  const Header({super.key, this.onYearChanged}); // Nuevo: Parámetro en el constructor

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late int _currentYear;

  @override
  void initState() {
    super.initState();
    _currentYear = DateTime.now().year; // Inicializa con el año actual
  }

  void _goToPreviousYear() {
    setState(() {
      _currentYear--;
    });
    widget.onYearChanged?.call(_currentYear); // Llama al callback con el nuevo año
  }

  void _goToNextYear() {
    setState(() {
      _currentYear++;
    });
    widget.onYearChanged?.call(_currentYear); // Llama al callback con el nuevo año
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botones de navegación por año a la izquierda
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
                  text: '$_currentYear',
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
