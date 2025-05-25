abstract class AppInternalConstants {
  // Chat internal strings (errors, hints for internal logic, API specifics)
  static const String chatApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  static const String chatApiRoleUser = 'user';
  static const String chatApiPartsKey = 'parts';
  static const String chatApiTextKey = 'text';
  static const String chatApiContentsKey = 'contents';
  static const String chatApiCandidatesKey = 'candidates';
  static const String chatApiContentKey = 'content';
  static const String chatApiContentTypeHeader = 'application/json';
  static const String chatErrorPrefix = 'Error: ';
  static const String chatThinkingHint = 'Thinking...';
  static const String chatNoAIResponse = 'Could not get a response from the AI.';
  static const String chatGeminiApiError = 'Gemini API Error: ';
  static const String chatResponseBody = 'Response Body: ';
  static const String chatConnectionError = 'Error connecting to AI: ';
  static const String chatUnexpectedError = 'An unexpected error occurred while sending the message.';
  static const String chatExceptionSendingMessage = 'Exception while sending message to AI: ';

  // Event internal strings (view model errors, internal types)
  static const String eventUserNotAuthenticated = 'User not authenticated.';
  static const String eventUserNotAuthenticatedSave = 'User not authenticated. Cannot save event.';
  static const String eventFailedToSave = 'Failed to save event: ';
  static const String eventFailedToUpdate = 'Failed to update event: ';
  static const String eventFailedToDelete = 'Failed to delete event: ';
  static const String eventFailedToFetch = 'Failed to fetch events: ';
  static const String eventFailedToFetchNearest = 'Failed to fetch nearest event: ';
  static const String eventFailedToFetchForMonth = 'Failed to fetch events for month: ';
  static const String eventFailedToFetchForYear = 'Failed to fetch events for year: ';

  // Event Type Strings (for internal use in _getEventTypeFromString and parsing)
  static const String eventTypeMeeting = 'meeting';
  static const String eventTypeExam = 'exam';
  static const String eventTypeConference = 'conference';
  static const String eventTypeAppointment = 'appointment';
  static const String eventTypeTask = 'task';
  static const String eventTypeAll = 'ALL';

  // Search internal strings (error messages, N/A for data display logic)
  static const String searchNA = 'N/A';
  static const String searchFailedToDeleteEvent = 'Failed to delete event: ';
  static const String searchFailedToLoadEvents = 'Failed to load events: ';

  // Dailies internal strings (error messages, N/A for data display logic)
  static const String dailiesFailedToLoadEvents = 'Failed to load daily events: ';
  static const String dailiesFailedToDeleteEvent = 'Failed to delete event: ';
  static const String dailiesNA = 'N/A';
  static const String dailiesLocaleEnUs = 'en_US';

  // Add Event internal strings (validation messages, error messages)
  static const String addEventValidationTitle = 'Please enter the event title';
  static const String addEventValidationDescription = 'Please enter the event description';
  static const String addEventValidationDate = 'Please select the event date';
  static const String addEventValidationDateTime = 'Please select the event date and time';
  static const String addEventFailedToSave = 'Failed to save event: ';
  static const String addEventFailedToUpdate = 'Failed to update event: ';
  static const String addEventDefaultTime = '01:00 AM';

  // Upcoming Event Card internal strings (default description)
  static const String upcomingEventDescriptionEmpty = 'No description provided.';

  // Monthly Calendar internal strings (error messages)
  static const String monthlyCalendarErrorLoadingEvents = 'Error loading events for month: ';
  static const String monthlyCalendarLocaleEnUs = 'en_US';

  // Calendar Screen Specific internal strings (error messages)
  static const String calendarErrorLoadingMonthlyCountsPrint = 'Error loading monthly event counts for year ';
  static const String calendarErrorMessagePrefix = 'Error: ';

  // Priority Values (Lowercase for parsing in switch statements)
  static const String priorityValueCritical = 'critical';
  static const String priorityValueHigh = 'high';
  static const String priorityValueMedium = 'medium';
  static const String priorityValueLow = 'low';

  // Sign-up/Sign-in internal status/error messages
  static const String signUpSuccess = 'Registration successful';
  static const String signUpFailure = 'Registration failed';
  static const String googleSignInCancelled = 'Google sign-in cancelled';
  static const String signUpPasswordsDoNotMatch = 'Passwords do not match';
  static const String signUpRegistrationFailedFallback = 'Registration failed';
  static const String signInFailed = 'Sign in failed';
  static const String signInErrorPrefix = 'Error: ';

  // Profile internal default values
  static const String profileUsernameDefault = 'User';
  static const String profileEmailDefault = 'email@domain.com';
  static const String functionalityNotImplemented = 'Functionality not yet implemented.';
}
