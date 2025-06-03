// Lógica para gestionar el cambio de año en el encabezado del calendario.
class HeaderLogic {
  int currentYear;
  HeaderLogic({required this.currentYear});

  // Disminuye el año actual y notifica el cambio.
  void goToPreviousYear(Function(int) onYearChanged) {
    currentYear--;
    onYearChanged(currentYear);
  }

  // Incrementa el año actual y notifica el cambio.
  void goToNextYear(Function(int) onYearChanged) {
    currentYear++;
    onYearChanged(currentYear);
  }
}
