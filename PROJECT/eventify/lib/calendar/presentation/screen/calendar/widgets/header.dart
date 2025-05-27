import 'package:eventify/calendar/presentation/screen/add_event/add_event_screen.dart';
import 'package:eventify/calendar/presentation/screen/search/search_events_screen.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

class Header extends StatefulWidget {
  final Function(int year)? onYearChanged;
  final int currentYear;

  const Header({
    super.key,
    this.onYearChanged,
    required this.currentYear,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late int _currentYear;

  @override
  void initState() {
    super.initState();
    _currentYear = widget.currentYear;
  }

  @override
  void didUpdateWidget(covariant Header oldWidget) {
    super.didUpdateWidget(oldWidget);
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
      color: AppColors.headerBackground.withOpacity(0.8), // Ajusta la opacidad si lo necesitas
      child: SizedBox(
        height: 64, // Ajusta la altura si lo necesitas
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end, // Alinea todos los hijos abajo
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _goToPreviousYear,
                    icon: const Icon(Icons.arrow_downward, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    onPressed: _goToNextYear,
                    icon: const Icon(Icons.arrow_upward, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 10),
              child: ShiningTextAnimation(
                text: '$_currentYear',
                style: TextStyles.urbanistBody1,
                shineColor: AppColors.shineEffectColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EventSearchScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AddEventScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}