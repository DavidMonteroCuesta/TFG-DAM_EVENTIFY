class HeaderLogic {
  int currentYear;
  HeaderLogic({required this.currentYear});

  void goToPreviousYear(Function(int) onYearChanged) {
    currentYear--;
    onYearChanged(currentYear);
  }

  void goToNextYear(Function(int) onYearChanged) {
    currentYear++;
    onYearChanged(currentYear);
  }
}
