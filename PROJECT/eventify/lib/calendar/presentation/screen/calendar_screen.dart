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
  const CalendarScreen({super.key});
  static const String routeName = '/calendar';

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _pageController = PageController(initialPage: 0);
  bool _isMonthlyView = false;
  late EventViewModel _eventViewModel;
  DateTime _focusedMonthForMonthlyView = DateTime.now();
  int _currentYear = DateTime.now().year; // Estado para el año actual

  @override
  void initState() {
    super.initState();
    _eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    // Llama a loadNearestEvent aquí para la carga inicial
    // El ViewModel se encargará de no recargar si ya está cargado (gracias a _isNearestEventLoaded)
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
      // Opcional: Si quieres que al cambiar el año en el Header, la vista mensual
      // también se actualice al mes actual de ese nuevo año (si no estás en vista mensual)
      _focusedMonthForMonthlyView = DateTime(year, DateTime.now().month, 1);
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
                child: Header(onYearChanged: _handleYearChanged), // Pasa el callback
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
                                        currentYear: _currentYear, // Pasa el año actual
                                      )),
                                  if (showEventCard) ...[
                                    SizedBox(
                                        height:
                                            spacingBetweenCalendarAndEvent),
                                    // Usa Consumer para escuchar cambios en EventViewModel
                                    Consumer<EventViewModel>(
                                      builder: (context, eventViewModel, child) {
                                        // NO LLAMAR eventViewModel.loadNearestEvent() AQUÍ.
                                        // Ya se llama en initState y se actualiza en el ViewModel
                                        // cuando los eventos cambian (add/update/delete).

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
                                            date: eventViewModel.nearestEvent!.dateTime!.toDate(), // Asegúrate de convertir Timestamp a DateTime
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
                                      currentYear: _currentYear, // Pasa el año actual
                                    )),
                                if (showEventCard) ...[
                                  SizedBox(
                                      height:
                                          spacingBetweenCalendarAndEvent),
                                  // Usa Consumer para escuchar cambios en EventViewModel
                                  Consumer<EventViewModel>(
                                    builder: (context, eventViewModel, child) {
                                      // NO LLAMAR eventViewModel.loadNearestEvent() AQUÍ.
                                      // Ya se llama en initState y se actualiza en el ViewModel
                                      // cuando los eventos cambian (add/update/delete).

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
                                          date: eventViewModel.nearestEvent!.dateTime!.toDate(), // Asegúrate de convertir Timestamp a DateTime
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
