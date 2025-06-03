class AppLogs {
  // Constantes para mensajes de log y errores en la app
  static const String firebaseAuthRegisterError =
      'Firebase Auth registration error.';
  static const String unexpectedRegisterError =
      'Unexpected error during registration.';
  static const String firestoreSaveUserError =
      'Error saving user to Firestore.';
  static const String firebaseAuthLoginError = 'Firebase Auth login error.';
  static const String unexpectedLoginError = 'Unexpected error during login.';
  static const String errorSavingGoogleUserInfo =
      'Error saving Google user info to Firestore.';
  static const String firebaseAuthResetPasswordError =
      'Error sending password reset email in Firebase Auth.';
  static const String unexpectedResetPasswordError =
      'Unexpected error during password reset.';
  static const String loginUseCaseError = 'LoginUseCase error: ';
  static const String googleSignInCancelled =
      'Google Sign-In cancelled by user.';
  static const String googleSignInAuthenticated =
      'Firebase user authenticated via Google: ';
  static const String googleSignInNullUser =
      'Firebase user is null after Google sign-in credential.';
  static const String googleSignInFirebaseAuthError =
      'Firebase Auth Error during Google Sign-In: ';
  static const String googleSignInUnexpectedError =
      'Unexpected Error during Google Sign-In: ';
  static const String chatGeminiApiError = 'Gemini API error:';
  static const String statusCode = 'status code:';
  static const String chatResponseBody = 'Gemini API response body:';
  static const String chatExceptionSendingMessage =
      'Exception while sending message to AI: ';
  static const String calendarErrorLoadingMonthlyCounts =
      'Error loading monthly event counts for year: ';
  static const String googleSignInUserUid = 'User UID after Google Sign-In: ';
  static const String eventAdded = 'Event added to Firestore for user:';
  static const String withId = 'with ID:';
  static const String eventAddError = 'Error adding event to Firestore:';
  static const String eventUpdated = 'Event updated in Firestore for user:';
  static const String andEvent = 'and event:';
  static const String eventUpdateError = 'Error updating event in Firestore:';
  static const String eventDeleted = 'Event deleted from Firestore for user:';
  static const String eventDeleteError = 'Error deleting event from Firestore:';
  static const String eventFetchError =
      'Error fetching events from Firestore for user:';
  static const String eventFetchNearestError =
      'Error while fetching the nearest event from Firestore for user:';
  static const String eventFetchByMonthError =
      'Error fetching events by user and month from Firestore:';
  static const String eventFetchByYear = 'Events fetched for year';
  static const String forUser = 'for user';
  static const String count = 'count:';
  static const String eventFetchByYearError =
      'Error fetching events by user and year from Firestore: ';
}
