import 'package:eventify/calendar/presentation/screen/add_event/add_event_screen.dart';
import 'package:eventify/calendar/presentation/screen/search/search_events_screen.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/common/constants/app_firestore_fields.dart';
import 'package:flutter/material.dart';

class CalendarLogic extends ChangeNotifier {
  static const int _monthlyPageIndex = 1;
  static const int _defaultPageIndex = 0;
  static const int _animationDurationMs = 300;

  late PageController pageController;
  late bool isMonthlyView;
  late EventViewModel eventViewModel;
  DateTime focusedMonthForMonthlyView = DateTime.now();
  int currentYear = DateTime.now().year;
  Key monthlyCalendarKey = UniqueKey();
  final BuildContext context;
  final bool showMonthlyView;

  // Lógica principal para gestionar la vista y navegación del calendario.
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
      isMonthlyView ? _monthlyPageIndex : _defaultPageIndex,
      duration: const Duration(milliseconds: _animationDurationMs),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void handleMonthSelected(int monthIndex) {
    focusedMonthForMonthlyView = DateTime(currentYear, monthIndex, 1);
    isMonthlyView = true;
    pageController.animateToPage(
      _monthlyPageIndex,
      duration: const Duration(milliseconds: _animationDurationMs),
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
    // Navega a la pantalla de búsqueda con la fecha seleccionada y recarga el evento más próximo si es necesario.
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
    safeEventData[AppFirestoreFields.title] =
        safeEventData[AppFirestoreFields.title] ?? '';
    safeEventData[AppFirestoreFields.description] =
        safeEventData[AppFirestoreFields.description] ?? '';
    safeEventData[AppFirestoreFields.location] =
        safeEventData[AppFirestoreFields.location] ?? '';
    safeEventData[AppFirestoreFields.subject] =
        safeEventData[AppFirestoreFields.subject] ?? '';
    safeEventData[AppFirestoreFields.withPerson] =
        safeEventData[AppFirestoreFields.withPerson] ?? '';
    safeEventData[AppFirestoreFields.type] =
        safeEventData[AppFirestoreFields.type]?.toString() ??
        AppFirestoreFields.typeTask;
    safeEventData[AppFirestoreFields.priority] =
        safeEventData[AppFirestoreFields.priority]?.toString() ??
        AppFirestoreFields.priority;

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
