import 'package:eventify/calendar/presentation/screen/calendar/logic/calendar_logic.dart';
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
import 'package:eventify/common/theme/colors/app_colors.dart';

class CalendarScreen extends StatelessWidget {
  static const String routeName = '/calendar';
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

class _CalendarScreenBodyState extends State<_CalendarScreenBody> {
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
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
                child: Header(
                  onYearChanged: logic.handleYearChanged,
                  currentYear: logic.currentYear,
                ),
              ),
              SizedBox(height: spacingBetweenHeaderAndCalendar),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                        onMonthSelected:
                                            logic.handleMonthSelected,
                                        currentYear: logic.currentYear,
                                      ),
                                      if (showEventCard) ...[
                                        const SizedBox(height: 16.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
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
                                      onMonthSelected:
                                          logic.handleMonthSelected,
                                      currentYear: logic.currentYear,
                                    ),
                                    if (showEventCard) ...[
                                      const SizedBox(height: 16.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
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
                                                      color: AppColors.primary,
                                                    ),
                                              );
                                            } else if (eventViewModel
                                                    .errorMessage !=
                                                null) {
                                              return Center(
                                                child: Text(
                                                  eventViewModel.errorMessage!,
                                                  style:
                                                      TextStyles.urbanistBody1,
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
                                              // Fallback para campos nulos
                                              final event =
                                                  eventViewModel.nearestEvent!;
                                              return UpcomingEventCard(
                                                title: event.title,
                                                type: event.type.toString(),
                                                date: event.dateTime!.toDate(),
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
                                                      TextStyles.urbanistBody1,
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
              SizedBox(height: spacingBetweenContentAndFooter),
              SizedBox(
                height: footerHeight,
                child: Footer(
                  onToggleCalendar: logic.toggleCalendarView,
                  isMonthlyView: logic.isMonthlyView,
                  onResetToCurrent: logic.resetCalendarToCurrent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
