import 'package:eventify/common/widgets/calendar/widgets/calendar.dart';
import 'package:eventify/common/widgets/calendar/widgets/footer.dart';
import 'package:eventify/common/widgets/calendar/widgets/header.dart';
import 'package:eventify/common/widgets/calendar/widgets/monthly_calendar.dart';
import 'package:eventify/common/widgets/calendar/widgets/upcoming_event_card.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _pageController = PageController(initialPage: 0);
  bool _isMonthlyView = false;

  final upcomingEvent = {
    'title': 'Reunión importante...',
    'type': 'Trabajo',
    'date': DateTime.parse('2025-04-11 10:00:00'),
    'priority': 'Crítica',
    'description': 'Discutir los avances del sprint actual...',
  };

  void _toggleCalendarView() {
    setState(() {
      _isMonthlyView = !_isMonthlyView;
      _pageController.animateToPage(
        _isMonthlyView ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double spacingBetweenHeaderAndCalendar = 30.0;
    const double spacingBetweenCalendarAndEvent = 20.0;
    const double spacingBetweenEventAndFooter = 20.0;
    final screenHeight = MediaQuery.of(context).size.height;
    final footerHeight = screenHeight * 0.08;

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final isTablet = constraints.maxWidth > 600 && constraints.maxWidth <= 900;
          final isDesktop = constraints.maxWidth > 900;

          return Column(
            children: [
              SizedBox(
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
                child: const Header(),
              ),
              SizedBox(height: spacingBetweenHeaderAndCalendar),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: isTablet || isDesktop
                      ? Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const Expanded(child: Calendar()),
                                const SizedBox(height: spacingBetweenCalendarAndEvent),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 32.0),
                                  child: UpcomingEventCard(
                                    title: upcomingEvent['title'] as String,
                                    type: upcomingEvent['type'] as String,
                                    date: upcomingEvent['date'] as DateTime,
                                    priority: upcomingEvent['priority'] as String,
                                    description: upcomingEvent['description'] as String,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          const Expanded(
                            flex: 1,
                            child: MonthlyCalendar(),
                          ),
                        ],
                      )
                      : Expanded(
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Column(
                                children: [
                                  const Calendar(), // Remueve el Expanded aquí
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20.0),
                                    child: UpcomingEventCard(
                                      title: upcomingEvent['title'] as String,
                                      type: upcomingEvent['type'] as String,
                                      date: upcomingEvent['date'] as DateTime,
                                      priority: upcomingEvent['priority'] as String,
                                      description: upcomingEvent['description'] as String,
                                    ),
                                  ),
                                ],
                              ),
                              const MonthlyCalendar(),
                            ],
                          ),
                        ),
                ),
              ),
              SizedBox(height: spacingBetweenEventAndFooter),
              SizedBox(
                height: footerHeight,
                child: Footer(
                  onToggleCalendar: _toggleCalendarView,
                  isMonthlyView: _isMonthlyView,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}