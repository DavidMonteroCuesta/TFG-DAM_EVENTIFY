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

  @override
  void initState() {
    super.initState();
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
    final eventViewModel = Provider.of<EventViewModel>(context);

    return Builder(builder: (context) {
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
                                    Expanded(child: const Calendar()),
                                    if (showEventCard) ...[
                                      SizedBox(
                                          height:
                                              spacingBetweenCalendarAndEvent),
                                      if (eventViewModel.isLoading)
                                        const CircularProgressIndicator()
                                      else if (eventViewModel.errorMessage !=
                                          null)
                                        Text(
                                          eventViewModel.errorMessage!,
                                          style: TextStyles.urbanistBody1,
                                        )
                                      else if (eventViewModel.nearestEvent != null)
                                        UpcomingEventCard(
                                          title:
                                              eventViewModel.nearestEvent!.title,
                                          type: eventViewModel
                                              .nearestEvent!.type
                                              .toString(),
                                          date: eventViewModel.nearestEvent!.dateTime!.toDate(),
                                          priority: eventViewModel
                                              .nearestEvent!.priority
                                              .toString(),
                                          description: eventViewModel
                                                  .nearestEvent!.description ??
                                              '',
                                        )
                                      else
                                        Text(
                                          'No hay eventos próximos.',
                                          style: TextStyles.urbanistBody1,
                                        ),
                                    ],
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
                        : PageView(
                            controller: _pageController,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            children: [
                              Column(
                                children: [
                                  Expanded(child: const Calendar()),
                                  if (showEventCard) ...[
                                    SizedBox(
                                        height:
                                            spacingBetweenCalendarAndEvent),
                                    if (eventViewModel.isLoading)
                                      const CircularProgressIndicator()
                                    else if (eventViewModel.errorMessage !=
                                        null)
                                      Text(
                                        eventViewModel.errorMessage!,
                                        style: TextStyles.urbanistBody1,
                                      )
                                    else if (eventViewModel.nearestEvent != null)
                                      UpcomingEventCard(
                                        title:
                                            eventViewModel.nearestEvent!.title,
                                        type: eventViewModel
                                            .nearestEvent!.type
                                            .toString(),
                                        date: eventViewModel.nearestEvent!.dateTime!.toDate(),
                                        priority: eventViewModel
                                            .nearestEvent!.priority
                                            .toString(),
                                        description: eventViewModel
                                                .nearestEvent!.description ??
                                            '',
                                      )
                                    else
                                      Text(
                                        'No hay eventos próximos.',
                                        style: TextStyles.urbanistBody1,
                                      ),
                                  ],
                                ],
                              ),
                              const MonthlyCalendar(),
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
    });
  }
}