import 'package:eventify/calendar/presentation/screen/calendar/logic/calendar_logic.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/calendar.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/footer.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/header.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/monthly_calendar.dart';
import 'package:eventify/calendar/presentation/screen/calendar/widgets/upcoming_event_card.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_routes.dart';
import 'package:eventify/common/constants/app_strings.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/main.dart';

class CalendarScreen extends StatelessWidget {
  static const String routeName = AppRoutes.calendar;
  final bool showMonthlyView;

  const CalendarScreen({super.key, this.showMonthlyView = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarLogic>(
      create:
          (_) =>
              CalendarLogic(context: context, showMonthlyView: showMonthlyView),
      child: const _CalendarScreenBody(),
    );
  }
}

class _CalendarScreenBody extends StatefulWidget {
  const _CalendarScreenBody();

  @override
  State<_CalendarScreenBody> createState() => _CalendarScreenBodyState();
}

class _CalendarScreenBodyState extends State<_CalendarScreenBody>
    with RouteAware {
  static const double _spacingBetweenHeaderAndCalendar = 10.0;
  static const double _spacingBetweenContentAndFooter = 10.0;
  static const double _footerHeightFraction = 0.10;
  static const double _heightThreshold = 760.0;
  static const double _tabletMinWidth = 900.0;
  static const double _tabletMaxWidth = 900.0;
  static const double _desktopMinWidth = 900.0;
  static const double _horizontalPadding = 16.0;
  static const double _eventCardSpacing = 16.0;
  static const double _monthlyCalendarWidth = 20.0;

  Key _calendarKey = UniqueKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      _calendarKey = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventViewModel>(context, listen: false).loadNearestEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<CalendarLogic>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final footerHeight = screenHeight * _footerHeightFraction;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final isTablet =
                constraints.maxWidth > _tabletMinWidth &&
                constraints.maxWidth <= _tabletMaxWidth;
            final isDesktop = constraints.maxWidth > _desktopMinWidth;

            bool showEventCard = constraints.maxHeight > _heightThreshold;

            return Column(
              children: [
                SizedBox(
                  height: kToolbarHeight + MediaQuery.of(context).padding.top,
                  child: Header(
                    onYearChanged: logic.handleYearChanged,
                    currentYear: logic.currentYear,
                  ),
                ),
                const SizedBox(height: _spacingBetweenHeaderAndCalendar),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _horizontalPadding,
                    ),
                    child:
                        isTablet || isDesktop
                            ? Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Calendar(
                                          key: _calendarKey,
                                          onMonthSelected:
                                              logic.handleMonthSelected,
                                          currentYear: logic.currentYear,
                                        ),
                                        if (showEventCard) ...[
                                          const SizedBox(
                                            height: _eventCardSpacing,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: _horizontalPadding,
                                            ),
                                            child: Consumer<EventViewModel>(
                                              builder: (
                                                context,
                                                eventViewModel,
                                                child,
                                              ) {
                                                if (eventViewModel.isLoading &&
                                                    eventViewModel
                                                            .nearestEvent ==
                                                        null) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                  );
                                                } else if (eventViewModel
                                                        .errorMessage !=
                                                    null) {
                                                  return Center(
                                                    child: Text(
                                                      eventViewModel
                                                          .errorMessage!,
                                                      style:
                                                          TextStyles
                                                              .urbanistBody1,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                } else if (eventViewModel
                                                        .nearestEvent !=
                                                    null) {
                                                  return UpcomingEventCard(
                                                    title:
                                                        eventViewModel
                                                            .nearestEvent!
                                                            .title,
                                                    type:
                                                        eventViewModel
                                                            .nearestEvent!
                                                            .type
                                                            .toString(),
                                                    date:
                                                        eventViewModel
                                                            .nearestEvent!
                                                            .dateTime!
                                                            .toDate(),
                                                    priority:
                                                        eventViewModel
                                                            .nearestEvent!
                                                            .priority
                                                            .toString(),
                                                    description:
                                                        eventViewModel
                                                            .nearestEvent!
                                                            .description ??
                                                        '',
                                                    onEdit:
                                                        () => logic
                                                            .onEditNearestEvent(
                                                              eventViewModel
                                                                  .nearestEvent!
                                                                  .toJson(),
                                                            ),
                                                    onTapCard:
                                                        () => logic
                                                            .navigateToSearchScreenWithNearestEvent(
                                                              eventViewModel
                                                                  .nearestEvent!
                                                                  .title,
                                                              eventViewModel
                                                                  .nearestEvent!
                                                                  .dateTime!
                                                                  .toDate(),
                                                            ),
                                                  );
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                      AppStrings.calendarNoUpcomingEvents(
                                                        context,
                                                      ),
                                                      style:
                                                          TextStyles
                                                              .urbanistBody1,
                                                      textAlign:
                                                          TextAlign.center,
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
                                const SizedBox(width: _monthlyCalendarWidth),
                                Expanded(
                                  flex: 1,
                                  child: MonthlyCalendar(
                                    key: logic.monthlyCalendarKey,
                                    initialFocusedDay:
                                        logic.focusedMonthForMonthlyView,
                                    onDaySelected:
                                        logic.navigateToSearchScreenWithDate,
                                  ),
                                ),
                              ],
                            )
                            : PageView(
                              controller: logic.pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Calendar(
                                        key: _calendarKey,
                                        onMonthSelected:
                                            logic.handleMonthSelected,
                                        currentYear: logic.currentYear,
                                      ),
                                      if (showEventCard) ...[
                                        const SizedBox(
                                          height: _eventCardSpacing,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: _horizontalPadding,
                                          ),
                                          child: Consumer<EventViewModel>(
                                            builder: (
                                              context,
                                              eventViewModel,
                                              child,
                                            ) {
                                              if (eventViewModel.isLoading &&
                                                  eventViewModel.nearestEvent ==
                                                      null) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                );
                                              } else if (eventViewModel
                                                      .errorMessage !=
                                                  null) {
                                                return Center(
                                                  child: Text(
                                                    eventViewModel
                                                        .errorMessage!,
                                                    style:
                                                        TextStyles
                                                            .urbanistBody1,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                              } else if (eventViewModel
                                                          .nearestEvent !=
                                                      null &&
                                                  eventViewModel
                                                      .nearestEvent!
                                                      .title
                                                      .isNotEmpty &&
                                                  eventViewModel
                                                          .nearestEvent!
                                                          .dateTime !=
                                                      null) {
                                                final event =
                                                    eventViewModel
                                                        .nearestEvent!;
                                                return UpcomingEventCard(
                                                  title: event.title,
                                                  type: event.type.toString(),
                                                  date:
                                                      event.dateTime!.toDate(),
                                                  priority:
                                                      event.priority.toString(),
                                                  description:
                                                      event.description ?? '',
                                                  onEdit:
                                                      () => logic
                                                          .onEditNearestEvent(
                                                            event.toJson(),
                                                          ),
                                                  onTapCard:
                                                      () => logic
                                                          .navigateToSearchScreenWithNearestEvent(
                                                            event.title,
                                                            event.dateTime!
                                                                .toDate(),
                                                          ),
                                                );
                                              } else {
                                                return Center(
                                                  child: Text(
                                                    AppStrings.calendarNoUpcomingEvents(
                                                      context,
                                                    ),
                                                    style:
                                                        TextStyles
                                                            .urbanistBody1,
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
                                  key: logic.monthlyCalendarKey,
                                  initialFocusedDay:
                                      logic.focusedMonthForMonthlyView,
                                  onDaySelected:
                                      logic.navigateToSearchScreenWithDate,
                                ),
                              ],
                            ),
                  ),
                ),
                const SizedBox(height: _spacingBetweenContentAndFooter),
                SizedBox(
                  height: footerHeight,
                  child:
                      (MediaQuery.of(context).size.width <= _tabletMinWidth)
                          ? Footer(
                            onToggleCalendar: logic.toggleCalendarView,
                            isMonthlyView: logic.isMonthlyView,
                            onResetToCurrent: logic.resetCalendarToCurrent,
                            showToggle: true,
                          )
                          : Footer(
                            onToggleCalendar: logic.toggleCalendarView,
                            isMonthlyView: logic.isMonthlyView,
                            onResetToCurrent: logic.resetCalendarToCurrent,
                            showToggle: false,
                          ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
