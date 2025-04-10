import 'package:eventify/src/widgets/calendar/elements/calendar.dart';
import 'package:eventify/src/widgets/calendar/elements/footer.dart';
import 'package:eventify/src/widgets/calendar/elements/header.dart';
import 'package:eventify/src/widgets/calendar/elements/upcoming_event_card.dart';
import 'package:flutter/material.dart';

class MonthsScreen extends StatelessWidget {
  const MonthsScreen({super.key});

  final upcomingEvent = const {
    'title': 'Reunión importante...',
    'type': 'Trabajo',
    'date': '2025-04-11 10:00:00',
    'priority': 'Crítica',
    'description': 'Discutir los avances del sprint actual...',
  };

  // Widget placeholder para el calendario futuro
  Widget _buildFutureCalendar() {
    return Container(
      color: Colors.grey[850],
      child: const Center(
        child: Text('Calendario Futuro (Placeholder)', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double spacingBetweenHeaderAndCalendar = 30.0;
    const double spacingBetweenCalendarAndEvent = 20.0;
    const double spacingBetweenEventAndFooter = 20.0;
    const double spacingBetweenCalendars = 20.0;

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
                                  SizedBox(height: spacingBetweenCalendarAndEvent),
                                  UpcomingEventCard(
                                    title: upcomingEvent['title'] as String,
                                    type: upcomingEvent['type'] as String,
                                    date: DateTime.parse(upcomingEvent['date'] as String),
                                    priority: upcomingEvent['priority'] as String,
                                    description: upcomingEvent['description'] as String,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: spacingBetweenCalendars),
                            Expanded(
                              flex: 1,
                              child: _buildFutureCalendar(), // Placeholder del calendario futuro
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const Expanded(child: Calendar()),
                            SizedBox(height: spacingBetweenCalendarAndEvent),
                            UpcomingEventCard(
                              title: upcomingEvent['title'] as String,
                              type: upcomingEvent['type'] as String,
                              date: DateTime.parse(upcomingEvent['date'] as String),
                              priority: upcomingEvent['priority'] as String,
                              description: upcomingEvent['description'] as String,
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: spacingBetweenEventAndFooter),
              SizedBox(
                height: kBottomNavigationBarHeight,
                child: const Footer(),
              ),
            ],
          );
        },
      ),
    );
  }
}