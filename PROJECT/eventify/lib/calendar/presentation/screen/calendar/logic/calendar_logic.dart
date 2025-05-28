import 'package:flutter/material.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/calendar/presentation/screen/add_event/add_event_screen.dart';
import 'package:eventify/calendar/presentation/screen/search/search_events_screen.dart';

class CalendarLogic extends ChangeNotifier {
  late PageController pageController;
  late bool isMonthlyView;
  late EventViewModel eventViewModel;
  DateTime focusedMonthForMonthlyView = DateTime.now();
  int currentYear = DateTime.now().year;
  Key monthlyCalendarKey = UniqueKey();
  final BuildContext context;
  final bool showMonthlyView;

  CalendarLogic({required this.context, this.showMonthlyView = false}) {
    isMonthlyView = showMonthlyView;
    pageController = PageController(initialPage: isMonthlyView ? 1 : 0);
    eventViewModel = EventViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventViewModel.loadNearestEvent();
    });
  }

  void toggleCalendarView() {
    isMonthlyView = !isMonthlyView;
    pageController.animateToPage(
      isMonthlyView ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void handleMonthSelected(int monthIndex) {
    focusedMonthForMonthlyView = DateTime(currentYear, monthIndex, 1);
    isMonthlyView = true;
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void handleYearChanged(int year) {
    currentYear = year;
    focusedMonthForMonthlyView = DateTime(year, DateTime.now().month, 1);
    notifyListeners();
  }

  void resetCalendarToCurrent() {
    currentYear = DateTime.now().year;
    focusedMonthForMonthlyView = DateTime.now();
    eventViewModel.loadNearestEvent();
    monthlyCalendarKey = UniqueKey();
    notifyListeners();
  }

  Future<void> navigateToSearchScreenWithDate(DateTime selectedDate) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => EventSearchScreen(initialSelectedDate: selectedDate),
      ),
    );
    if (result == true) {
      eventViewModel.loadNearestEvent();
      monthlyCalendarKey = UniqueKey();
      notifyListeners();
    }
  }

  Future<void> onEditNearestEvent(Map<String, dynamic> eventData) async {
    Map<String, dynamic> safeEventData = Map.from(eventData);
    safeEventData['title'] = safeEventData['title'] ?? '';
    safeEventData['description'] = safeEventData['description'] ?? '';
    safeEventData['location'] = safeEventData['location'] ?? '';
    safeEventData['subject'] = safeEventData['subject'] ?? '';
    safeEventData['withPerson'] = safeEventData['withPerson'] ?? '';
    safeEventData['type'] =
        safeEventData['type']?.toString() ?? AppInternalConstants.eventTypeTask;
    safeEventData['priority'] =
        safeEventData['priority']?.toString() ??
        AppInternalConstants.priorityValueLow;

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEventScreen(eventToEdit: safeEventData),
      ),
    );
    if (result == true) {
      eventViewModel.loadNearestEvent();
      notifyListeners();
    }
  }

  Future<void> navigateToSearchScreenWithNearestEvent(
    String title,
    DateTime date,
  ) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => EventSearchScreen(
              initialSearchTitle: title,
              initialSelectedDate: date,
            ),
      ),
    );
    if (result == true) {
      eventViewModel.loadNearestEvent();
      monthlyCalendarKey = UniqueKey();
      notifyListeners();
    }
  }

  void disposeLogic() {
    pageController.dispose();
  }
}
