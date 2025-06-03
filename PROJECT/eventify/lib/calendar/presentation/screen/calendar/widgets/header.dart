// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:ui';

import 'package:eventify/calendar/presentation/screen/add_event/add_event_screen.dart';
import 'package:eventify/calendar/presentation/screen/calendar/logic/header_logic.dart';
import 'package:eventify/calendar/presentation/screen/search/search_events_screen.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widget que muestra el encabezado del calendario, permitiendo cambiar de año y acceder a búsqueda o añadir eventos.
class Header extends StatefulWidget {
  final Function(int year)? onYearChanged;
  final int currentYear;

  const Header({super.key, this.onYearChanged, required this.currentYear});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  static const double _horizontalPadding = 16.0;
  static const double _headerHeight = 64.0;
  static const double _bottomPadding = 10.0;
  static const double _headerOpacity = 0.8;
  static const double _blurSigma = 10.0;

  late int _currentYear;
  late HeaderLogic _logic;

  @override
  void initState() {
    super.initState();
    _currentYear = widget.currentYear;
    _logic = HeaderLogic(currentYear: _currentYear);
  }

  @override
  void didUpdateWidget(covariant Header oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentYear != oldWidget.currentYear) {
      setState(() {
        _currentYear = widget.currentYear;
        _logic.currentYear = _currentYear;
      });
    }
  }

  void _goToPreviousYear() {
    setState(() {
      _logic.goToPreviousYear((year) {
        _currentYear = year;
        widget.onYearChanged?.call(_currentYear);
      });
    });
  }

  void _goToNextYear() {
    setState(() {
      _logic.goToNextYear((year) {
        _currentYear = year;
        widget.onYearChanged?.call(_currentYear);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Encabezado con botones para cambiar de año, buscar y añadir eventos.
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          color: AppColors.headerBackground.withOpacity(_headerOpacity),
          child: SizedBox(
            height: _headerHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: _bottomPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: _goToPreviousYear,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: _goToNextYear,
                        icon: const Icon(
                          Icons.arrow_upward,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: _bottomPadding),
                  child: ShiningTextAnimation(
                    text: '$_currentYear',
                    style: TextStyles.urbanistBody1,
                    shineColor: AppColors.shineEffectColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: _bottomPadding),
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
                        icon: const Icon(
                          Icons.search,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AddEventScreen(),
                            ),
                          );
                          if (result == true && mounted) {
                            Provider.of<EventViewModel>(
                              context,
                              listen: false,
                            ).loadNearestEvent(force: true);
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
