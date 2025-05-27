import 'package:eventify/calendar/presentation/screen/search/search_events_screen.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/calendar.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/footer.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/header.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/monthly_calendar.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/upcoming_event_card.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/calendar/presentation/screen/add_event/add_event_screen.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';

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
      _monthlyCalendarKey = UniqueKey();
    });
  }

  // Method to navigate to EventSearchScreen with selected date
  Future<void> _navigateToSearchScreenWithDate(DateTime selectedDate) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventSearchScreen(initialSelectedDate: selectedDate),
      ),
    );

    // If an event was added/edited/deleted in search, reload nearest event
    if (result == true) {
      _eventViewModel.loadNearestEvent();
      _monthlyCalendarKey = UniqueKey(); // Force MonthlyCalendar to rebuild
      setState(() {}); // Trigger a rebuild of the CalendarScreen
    }
  }

  // New method to handle editing the nearest event
  Future<void> _onEditNearestEvent(Map<String, dynamic> eventData) async {
    // Create a mutable copy to modify and ensure all string fields are not null
    Map<String, dynamic> safeEventData = Map.from(eventData);

    // Provide empty string as fallback for potentially null string fields
    safeEventData['title'] = safeEventData['title'] ?? '';
    safeEventData['description'] = safeEventData['description'] ?? '';
    safeEventData['location'] = safeEventData['location'] ?? '';
    safeEventData['subject'] = safeEventData['subject'] ?? '';
    safeEventData['withPerson'] = safeEventData['withPerson'] ?? '';
    safeEventData['type'] = safeEventData['type']?.toString() ?? AppInternalConstants.eventTypeTask;
    safeEventData['priority'] = safeEventData['priority']?.toString() ?? AppInternalConstants.priorityValueLow;

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEventScreen(eventToEdit: safeEventData),
      ),
    );

    if (mounted) {
      if (result == true) {
        _eventViewModel.loadNearestEvent();
      }
    }
  }

  // Nuevo método para navegar a la pantalla de búsqueda con el evento más próximo
  Future<void> _navigateToSearchScreenWithNearestEvent(String title, DateTime date) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventSearchScreen(
          initialSearchTitle: title,
          initialSelectedDate: date,
        ),
      ),
    );

    // Si se añadió/editó/eliminó un evento en la búsqueda, recarga el evento más próximo
    if (result == true) {
      _eventViewModel.loadNearestEvent();
      _monthlyCalendarKey = UniqueKey(); // Fuerza la reconstrucción del MonthlyCalendar
      setState(() {}); // Dispara una reconstrucción de CalendarScreen
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double spacingBetweenHeaderAndCalendar = 10.0;
    const double spacingBetweenContentAndFooter = 10.0;
    final screenHeight = MediaQuery.of(context).size.height;
    final footerHeight = screenHeight * 0.10;
    final double heightThreshold = 760;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                              child: SingleChildScrollView( // Reverted to SingleChildScrollView
                                child: Column(
                                  children: [
                                    Calendar(
                                      onMonthSelected: _handleMonthSelected,
                                      currentYear: _currentYear,
                                    ),
                                    if (showEventCard) ...[
                                      const SizedBox(height: 16.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Consumer<EventViewModel>(
                                          builder: (context, eventViewModel, child) {
                                            if (eventViewModel.isLoading && eventViewModel.nearestEvent == null) {
                                              return Center(child: CircularProgressIndicator(color: AppColors.primary));
                                            } else if (eventViewModel.errorMessage != null) {
                                              return Center(
                                                child: Text(
                                                  eventViewModel.errorMessage!,
                                                  style: TextStyles.urbanistBody1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            } else if (eventViewModel.nearestEvent != null) {
                                              return UpcomingEventCard(
                                                title: eventViewModel.nearestEvent!.title,
                                                type: eventViewModel.nearestEvent!.type.toString(),
                                                date: eventViewModel.nearestEvent!.dateTime!.toDate(),
                                                priority: eventViewModel.nearestEvent!.priority.toString(),
                                                description: eventViewModel.nearestEvent!.description ?? '',
                                                onEdit: () => _onEditNearestEvent(eventViewModel.nearestEvent!.toJson()),
                                                onTapCard: () => _navigateToSearchScreenWithNearestEvent(
                                                  eventViewModel.nearestEvent!.title,
                                                  eventViewModel.nearestEvent!.dateTime!.toDate(),
                                                ),
                                              );
                                            } else {
                                              return Center(
                                                child: Text(
                                                  AppStrings.calendarNoUpcomingEvents(context),
                                                  style: TextStyles.urbanistBody1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              flex: 1,
                              child: MonthlyCalendar(
                                key: _monthlyCalendarKey,
                                initialFocusedDay: _focusedMonthForMonthlyView,
                                onDaySelected: _navigateToSearchScreenWithDate,
                              ),
                            ),
                          ],
                        )
                      : PageView( // Mobile view
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            SingleChildScrollView( // Reverted to SingleChildScrollView
                              child: Column(
                                children: [
                                  Calendar(
                                    onMonthSelected: _handleMonthSelected,
                                    currentYear: _currentYear,
                                  ),
                                  if (showEventCard) ...[
                                    const SizedBox(height: 16.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Consumer<EventViewModel>(
                                        builder: (context, eventViewModel, child) {
                                          if (eventViewModel.isLoading && eventViewModel.nearestEvent == null) {
                                            return Center(child: CircularProgressIndicator(color: AppColors.primary));
                                          } else if (eventViewModel.errorMessage != null) {
                                            return Center(
                                              child: Text(
                                                eventViewModel.errorMessage!,
                                                style: TextStyles.urbanistBody1,
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          } else if (eventViewModel.nearestEvent != null) {
                                            return UpcomingEventCard(
                                              title: eventViewModel.nearestEvent!.title,
                                              type: eventViewModel.nearestEvent!.type.toString(),
                                              date: eventViewModel.nearestEvent!.dateTime!.toDate(),
                                              priority: eventViewModel.nearestEvent!.priority.toString(),
                                              description: eventViewModel.nearestEvent!.description ?? '',
                                              onEdit: () => _onEditNearestEvent(eventViewModel.nearestEvent!.toJson()),
                                              onTapCard: () => _navigateToSearchScreenWithNearestEvent(
                                                eventViewModel.nearestEvent!.title,
                                                eventViewModel.nearestEvent!.dateTime!.toDate(),
                                              ),
                                            );
                                          } else {
                                            return Center(
                                              child: Text(
                                                AppStrings.calendarNoUpcomingEvents(context),
                                                style: TextStyles.urbanistBody1,
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            MonthlyCalendar(
                              key: _monthlyCalendarKey,
                              initialFocusedDay: _focusedMonthForMonthlyView,
                              onDaySelected: _navigateToSearchScreenWithDate,
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: spacingBetweenContentAndFooter), // Changed spacing constant
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
