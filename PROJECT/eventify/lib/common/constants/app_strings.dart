abstract class AppStrings {
  // Chat strings
  static const String chatErrorPrefix = 'Error: ';
  static const String chatInitialBotGreeting = "Hello! I am your Eventify assistant. How can I help you with your schedule today?";
  static const String chatThinkingHint = 'Thinking...';
  static const String chatInputHint = 'Escribe un mensaje...';
  static const String chatScreenTitle = 'Chat with Eventify';
  static const String chatUserDefaultName = 'Tú';
  static const String chatAIAvatarLetters = 'EV';
  static const String chatNoAIResponse = 'No se pudo obtener una respuesta de la IA.';
  static const String chatGeminiApiError = 'Error en la API de Gemini: ';
  static const String chatResponseBody = 'Cuerpo de la respuesta: ';
  static const String chatConnectionError = 'Error al conectar con la IA: ';
  static const String chatUnexpectedError = 'Ocurrió un error inesperado al enviar el mensaje.';
  static const String chatExceptionSendingMessage = 'Excepción al enviar mensaje a la IA: ';

  // Profile Screen Strings
  static const String profileUsernameDefault = 'Usuario';
  static const String profileEmailDefault = 'email@dominio.com';
  static const String profileYourAccountTitle = 'Your Account';
  static const String profileEditProfileText = 'Edit Profile';
  static const String profileNotificationSettingsText = 'Notification Settings';
  static const String profileAppSettingsTitle = 'App Settings';
  static const String profileSupportText = 'Support';
  static const String profileTermsOfServiceText = 'Terms of Service';
  static const String profileLogoutButton = 'Log Out';
  static const String profileContactUsText = 'Contact us at: ejemplotfgdavid@gmail.com';
  static const String functionalityNotImplemented = 'Functionality not yet implemented.';

  // Event ViewModel Strings
  static const String eventUserNotAuthenticated = 'User not authenticated.';
  static const String eventUserNotAuthenticatedSave = 'User not authenticated. Cannot save event.';
  static const String eventFailedToSave = 'Failed to save event: ';
  static const String eventFailedToUpdate = 'Failed to update event: ';
  static const String eventFailedToDelete = 'Failed to delete event: ';
  static const String eventFailedToFetch = 'Failed to fetch events: ';
  static const String eventFailedToFetchNearest = 'Failed to fetch nearest event: ';
  static const String eventFailedToFetchForMonth = 'Failed to fetch events for month: ';
  static const String eventFailedToFetchForYear = 'Failed to fetch events for year: ';

  // Event Type Strings (for internal use in _getEventTypeFromString and display)
  static const String eventTypeMeeting = 'meeting';
  static const String eventTypeExam = 'exam';
  static const String eventTypeConference = 'conference';
  static const String eventTypeAppointment = 'appointment';
  static const String eventTypeTask = 'task';
  static const String eventTypeAll = 'ALL'; // For EventType.all display

  // Event Search Screen Strings
  static const String searchEventsTitle = 'SEARCH EVENTS';
  static const String searchFieldEventTitle = 'Event Title';
  static const String searchFieldDescription = 'Description';
  static const String searchFieldDate = 'Date (YYYY-MM-DD)';
  static const String searchFieldSelectDate = 'Select Date';
  static const String searchFieldEventType = 'Event Type';
  static const String searchFieldPriority = 'Priority';
  static const String searchPriorityCritical = 'CRITICAL';
  static const String searchPriorityHigh = 'HIGH';
  static const String searchPriorityMedium = 'MEDIUM';
  static const String searchPriorityLow = 'LOW';
  static const String searchFieldLocation = 'Location';
  static const String searchFieldSubject = 'Subject';
  static const String searchFieldWithPersonYesNo = 'With Person (Yes/No):';
  static const String searchFieldWithPerson = 'With Person';
  static const String searchResultsPrefix = 'Search Results (';
  static const String searchResultsSuffix = ')';
  static const String searchNA = 'N/A';
  static const String searchDateAndTimePrefix = 'Date and Time: ';
  static const String searchTypePrefix = 'Type: ';
  static const String searchDescriptionPrefix = 'Description: ';
  static const String searchPriorityPrefix = 'Priority: ';
  static const String searchLocationPrefix = 'Location: ';
  static const String searchSubjectPrefix = 'Subject: ';
  static const String searchWithPersonPrefix = 'With Person: ';
  static const String searchEventTypeMeetingDisplay = 'Meeting';
  static const String searchEventTypeExamDisplay = 'Exam';
  static const String searchEventTypeConferenceDisplay = 'Conference';
  static const String searchEventTypeAppointmentDisplay = 'Appointment';
  static const String searchEventTypeTaskDisplay = 'Task';
  static const String searchDeleteEventTitle = 'Delete Event';
  static const String searchDeleteEventConfirmPrefix = 'Are you sure you want to delete "';
  static const String searchDeleteEventConfirmSuffix = '"?';
  static const String searchCancelButton = 'Cancel';
  static const String searchDeleteButton = 'Delete';
  static const String searchEventDeletedSuccessPrefix = 'Event "';
  static const String searchEventDeletedSuccessSuffix = '" deleted successfully!';
  static const String searchFailedToDeleteEvent = 'Failed to delete event: ';
  static const String searchFailedToLoadEvents = 'Failed to load events: ';

  // Dailies Event Screen Strings
  static const String dailiesFailedToLoadEvents = 'Failed to load daily events: ';
  static const String dailiesDeleteEventTitle = 'Delete Event';
  static const String dailiesDeleteEventConfirmPrefix = 'Are you sure you want to delete "';
  static const String dailiesDeleteEventConfirmSuffix = '"?';
  static const String dailiesCancelButton = 'Cancel';
  static const String dailiesDeleteButton = 'Delete';
  static const String dailiesEventDeletedSuccessPrefix = 'Event "';
  static const String dailiesEventDeletedSuccessSuffix = '" deleted successfully!';
  static const String dailiesFailedToDeleteEvent = 'Failed to delete event: ';
  static const String dailiesNoEventsForThisDay = 'No events for this day.';
  static const String dailiesEventsForPrefix = 'Events for ';
  static const String dailiesEventsCountSeparator = ' (';
  static const String dailiesEventsCountSuffix = ')';
  static const String dailiesNA = 'N/A';
  static const String dailiesTimePrefix = 'Time: ';
  static const String dailiesTypePrefix = 'Type: ';
  static const String dailiesDescriptionPrefix = 'Description: ';
  static const String dailiesPriorityPrefix = 'Priority: ';
  static const String dailiesMeetingDisplay = 'Meeting';
  static const String dailiesExamDisplay = 'Exam';
  static const String dailiesConferenceDisplay = 'Conference';
  static const String dailiesAppointmentDisplay = 'Appointment';
  static const String dailiesTaskDisplay = 'Task';
}
