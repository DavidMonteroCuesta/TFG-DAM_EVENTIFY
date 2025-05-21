import 'package:eventify/calendar/presentation/screen/widgets/calendar.dart';
import 'package:eventify/calendar/presentation/screen/widgets/footer.dart';
import 'package:eventify/calendar/presentation/screen/widgets/header.dart';
import 'package:eventify/calendar/presentation/screen/widgets/monthly_calendar.dart';
import 'package:eventify/calendar/presentation/screen/widgets/upcoming_event_card.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  static const String routeName = '/calendar';
  final bool showMonthlyView;

  const CalendarScreen({
    super.key,
    this.showMonthlyView = false,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late PageController _pageController;
  late bool _isMonthlyView;
  late EventViewModel _eventViewModel;
  DateTime _focusedMonthForMonthlyView = DateTime.now();
  int _currentYear = DateTime.now().year;
  Key _monthlyCalendarKey = UniqueKey(); // Key para forzar la reconstrucción del MonthlyCalendar

  @override
  void initState() {
    super.initState();
    _isMonthlyView = widget.showMonthlyView;
    _pageController = PageController(initialPage: _isMonthlyView ? 1 : 0);

    _eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventViewModel.loadNearestEvent();
    });
  }

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

  void _handleMonthSelected(int monthIndex) {
    setState(() {
      _focusedMonthForMonthlyView = DateTime(_currentYear, monthIndex, 1);
      _isMonthlyView = true;
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _handleYearChanged(int year) {
    setState(() {
      _currentYear = year;
      _focusedMonthForMonthlyView = DateTime(year, DateTime.now().month, 1);
    });
  }

  void _resetCalendarToCurrent() {
    setState(() {
      _currentYear = DateTime.now().year;
      _focusedMonthForMonthlyView = DateTime.now();
      _eventViewModel.loadNearestEvent();
      // CLAVE: Cambia la Key del MonthlyCalendar para forzar su reconstrucción
      _monthlyCalendarKey = UniqueKey();
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
    final double heightThreshold = 865;

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final isTablet =
              constraints.maxWidth > 600 && constraints.maxWidth <= 900;
          final isDesktop = constraints.maxWidth > 900;

          bool showEventCard = constraints.maxHeight > heightThreshold;

          return Column(
            children: [
              SizedBox(
                height:
                    kToolbarHeight + MediaQuery.of(context).padding.top,
                child: Header(
                  onYearChanged: _handleYearChanged,
                  currentYear: _currentYear,
                ),
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
                                  Expanded(
                                      child: Calendar(
                                        onMonthSelected: _handleMonthSelected,
                                        currentYear: _currentYear,
                                      )),
                                  if (showEventCard) ...[
                                    SizedBox(
                                        height:
                                            spacingBetweenCalendarAndEvent),
                                    Consumer<EventViewModel>(
                                      builder: (context, eventViewModel, child) {
                                        if (eventViewModel.isLoading && eventViewModel.nearestEvent == null) {
                                          return const CircularProgressIndicator();
                                        } else if (eventViewModel.errorMessage != null) {
                                          return Text(
                                            eventViewModel.errorMessage!,
                                            style: TextStyles.urbanistBody1,
                                          );
                                        } else if (eventViewModel.nearestEvent != null) {
                                          return UpcomingEventCard(
                                            title: eventViewModel.nearestEvent!.title,
                                            type: eventViewModel.nearestEvent!.type.toString(),
                                            date: eventViewModel.nearestEvent!.dateTime!.toDate(),
                                            priority: eventViewModel.nearestEvent!.priority.toString(),
                                            description: eventViewModel.nearestEvent!.description ?? '',
                                          );
                                        } else {
                                          return Text(
                                            'No hay eventos próximos.',
                                            style: TextStyles.urbanistBody1,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              flex: 1,
                              child: MonthlyCalendar(
                                key: _monthlyCalendarKey, // Asigna la Key aquí
                                initialFocusedDay: _focusedMonthForMonthlyView,
                              ),
                            ),
                          ],
                        )
                      : PageView(
                          controller: _pageController,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          children: [
                            Column(
                              children: [
                                Expanded(
                                    child: Calendar(
                                      onMonthSelected: _handleMonthSelected,
                                      currentYear: _currentYear,
                                    )),
                                if (showEventCard) ...[
                                  SizedBox(
                                      height:
                                          spacingBetweenCalendarAndEvent),
                                  Consumer<EventViewModel>(
                                    builder: (context, eventViewModel, child) {
                                      // **CORRECCIÓN AQUÍ**: Asegura la sintaxis correcta del if/else if/else
                                      if (eventViewModel.isLoading && eventViewModel.nearestEvent == null) {
                                        return const CircularProgressIndicator();
                                      } else if (eventViewModel.errorMessage != null) {
                                        return Text(
                                          eventViewModel.errorMessage!,
                                          style: TextStyles.urbanistBody1,
                                        );
                                      } else if (eventViewModel.nearestEvent != null) {
                                        return UpcomingEventCard(
                                          title: eventViewModel.nearestEvent!.title,
                                          type: eventViewModel.nearestEvent!.type.toString(),
                                          date: eventViewModel.nearestEvent!.dateTime!.toDate(),
                                          priority: eventViewModel.nearestEvent!.priority.toString(),
                                          description: eventViewModel.nearestEvent!.description ?? '',
                                        );
                                      } else {
                                        return Text(
                                          'No hay eventos próximos.',
                                          style: TextStyles.urbanistBody1,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ],
                            ),
                            MonthlyCalendar(
                              key: _monthlyCalendarKey, // Asigna la Key aquí
                              initialFocusedDay: _focusedMonthForMonthlyView,
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: spacingBetweenEventAndFooter),
              SizedBox(
                height: footerHeight,
                child: Footer(
                  onToggleCalendar: _toggleCalendarView,
                  isMonthlyView: _isMonthlyView,
                  onResetToCurrent: _resetCalendarToCurrent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}