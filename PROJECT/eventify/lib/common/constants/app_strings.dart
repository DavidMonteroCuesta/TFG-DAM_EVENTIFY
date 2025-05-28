import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class AppStrings {
  // Chat strings (display only)
  static String chatInitialBotGreeting(BuildContext context) =>
      AppLocalizations.of(context)!.chatInitialBotGreeting;
  static String chatInputHint(BuildContext context) =>
      AppLocalizations.of(context)!.chatInputHint;
  static String chatScreenTitle(BuildContext context) =>
      AppLocalizations.of(context)!.chatScreenTitle;
  static String chatUserDefaultName(BuildContext context) =>
      AppLocalizations.of(context)!.chatUserDefaultName;
  static String chatAIAvatarLetters(BuildContext context) =>
      AppLocalizations.of(context)!.chatAIAvatarLetters;

  // Profile Screen Strings (display only)
  static String profileYourAccountTitle(BuildContext context) =>
      AppLocalizations.of(context)!.profileYourAccountTitle;
  static String profileEditProfileText(BuildContext context) =>
      AppLocalizations.of(context)!.profileEditProfileText;
  static String profileNotificationSettingsText(BuildContext context) =>
      AppLocalizations.of(context)!.profileNotificationSettingsText;
  static String profileAppSettingsTitle(BuildContext context) =>
      AppLocalizations.of(context)!.profileAppSettingsTitle;
  static String profileSupportText(BuildContext context) =>
      AppLocalizations.of(context)!.profileSupportText;
  static String profileTermsOfServiceText(BuildContext context) =>
      AppLocalizations.of(context)!.profileTermsOfServiceText;
  static String profileLogoutButton(BuildContext context) =>
      AppLocalizations.of(context)!.profileLogoutButton;
  static String profileContactUsText(BuildContext context) =>
      AppLocalizations.of(context)!.profileContactUsText;

  // New Theme-related strings for Profile Screen
  static String profileThemesText(BuildContext context) =>
      AppLocalizations.of(context)!.profileThemesText;
  static String themeSelectSecondaryColor(BuildContext context) =>
      AppLocalizations.of(context)!.themeSelectSecondaryColor;
  static String themeOptionGreenAccent(BuildContext context) =>
      AppLocalizations.of(context)!.themeOptionGreenAccent;
  static String themeOptionBlueAccent(BuildContext context) =>
      AppLocalizations.of(context)!.themeOptionBlueAccent;
  static String themeOptionOrangeAccent(BuildContext context) =>
      AppLocalizations.of(context)!.themeOptionOrangeAccent;
  static String themeOptionRedAccent(BuildContext context) =>
      AppLocalizations.of(context)!.themeOptionRedAccent;

  // Event Search Screen Strings (display only)
  static String searchEventsTitle(BuildContext context) =>
      AppLocalizations.of(context)!.searchEventsTitle;
  static String searchFieldEventTitle(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldEventTitle;
  static String searchFieldDescription(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldDescription;
  static String searchFieldDate(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldDate;
  static String searchFieldSelectDate(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldSelectDate;
  static String searchFieldEventType(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldEventType;
  static String searchFieldPriority(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldPriority;
  static String searchPriorityCritical(BuildContext context) =>
      AppLocalizations.of(context)!.searchPriorityCritical;
  static String searchPriorityHigh(BuildContext context) =>
      AppLocalizations.of(context)!.searchPriorityHigh;
  static String searchPriorityMedium(BuildContext context) =>
      AppLocalizations.of(context)!.searchPriorityMedium;
  static String searchPriorityLow(BuildContext context) =>
      AppLocalizations.of(context)!.searchPriorityLow;
  static String searchFieldLocation(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldLocation;
  static String searchFieldSubject(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldSubject;
  static String searchFieldWithPersonYesNo(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldWithPersonYesNo;
  static String searchFieldWithPerson(BuildContext context) =>
      AppLocalizations.of(context)!.searchFieldWithPerson;
  static String searchResultsPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchResultsPrefix;
  static String searchResultsSuffix(BuildContext context) =>
      AppLocalizations.of(context)!.searchResultsSuffix;
  static String searchDateAndTimePrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchDateAndTimePrefix;
  static String searchTypePrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchTypePrefix;
  static String searchDescriptionPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchDescriptionPrefix;
  static String searchPriorityPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchPriorityPrefix;
  static String searchLocationPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchLocationPrefix;
  static String searchSubjectPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchSubjectPrefix;
  static String searchWithPersonPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchWithPersonPrefix;
  static String searchEventTypeMeetingDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.searchEventTypeMeetingDisplay;
  static String searchEventTypeExamDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.searchEventTypeExamDisplay;
  static String searchEventTypeConferenceDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.searchEventTypeConferenceDisplay;
  static String searchEventTypeAppointmentDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.searchEventTypeAppointmentDisplay;
  static String searchEventTypeTaskDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.searchEventTypeTaskDisplay;
  static String searchEventTypeAllDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.searchEventTypeAllDisplay;
  static String searchDeleteEventTitle(BuildContext context) =>
      AppLocalizations.of(context)!.searchDeleteEventTitle;
  static String searchDeleteEventConfirmPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchDeleteEventConfirmPrefix;
  static String searchDeleteEventConfirmSuffix(BuildContext context) =>
      AppLocalizations.of(context)!.searchDeleteEventConfirmSuffix;
  static String searchCancelButton(BuildContext context) =>
      AppLocalizations.of(context)!.searchCancelButton;
  static String searchDeleteButton(BuildContext context) =>
      AppLocalizations.of(context)!.searchDeleteButton;
  static String searchEventDeletedSuccessPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.searchEventDeletedSuccessPrefix;
  static String searchEventDeletedSuccessSuffix(BuildContext context) =>
      AppLocalizations.of(context)!.searchEventDeletedSuccessSuffix;

  // Dailies Event Screen Strings (display only)
  static String dailiesDeleteEventTitle(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesDeleteEventTitle;
  static String dailiesDeleteEventConfirmPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesDeleteEventConfirmPrefix;
  static String dailiesDeleteEventConfirmSuffix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesDeleteEventConfirmSuffix;
  static String dailiesCancelButton(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesCancelButton;
  static String dailiesDeleteButton(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesDeleteButton;
  static String dailiesEventDeletedSuccessPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesEventDeletedSuccessPrefix;
  static String dailiesEventDeletedSuccessSuffix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesEventDeletedSuccessSuffix;
  static String dailiesNoEventsForThisDay(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesNoEventsForThisDay;
  static String dailiesEventsForPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesEventsForPrefix;
  static String dailiesEventsCountSeparator(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesEventsCountSeparator;
  static String dailiesEventsCountSuffix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesEventsCountSuffix;
  static String dailiesTimePrefix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesTimePrefix;
  static String dailiesTypePrefix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesTypePrefix;
  static String dailiesDescriptionPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesDescriptionPrefix;
  static String dailiesPriorityPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesPriorityPrefix;
  static String dailiesMeetingDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesMeetingDisplay;
  static String dailiesExamDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesExamDisplay;
  static String dailiesConferenceDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesConferenceDisplay;
  static String dailiesAppointmentDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesAppointmentDisplay;
  static String dailiesTaskDisplay(BuildContext context) =>
      AppLocalizations.of(context)!.dailiesTaskDisplay;

  // Calendar Screen Strings (display only)
  static String calendarNoUpcomingEvents(BuildContext context) =>
      AppLocalizations.of(context)!.calendarNoUpcomingEvents;

  // Add Event Screen Strings (display only)
  static String addEventCreateTitle(BuildContext context) =>
      AppLocalizations.of(context)!.addEventCreateTitle;
  static String addEventEditTitle(BuildContext context) =>
      AppLocalizations.of(context)!.addEventEditTitle;
  static String addEventFieldTitle(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldTitle;
  static String addEventFieldDescription(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldDescription;
  static String addEventFieldPriority(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldPriority;
  static String addEventFieldNotification(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldNotification;
  static String addEventFieldDate(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldDate;
  static String addEventSelectDate(BuildContext context) =>
      AppLocalizations.of(context)!.addEventSelectDate;
  static String addEventFieldTime(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldTime;
  static String addEventSelectTime(BuildContext context) =>
      AppLocalizations.of(context)!.addEventSelectTime;
  static String addEventFieldEventType(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldEventType;
  static String addEventFieldLocation(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldLocation;
  static String addEventFieldSubject(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldSubject;
  static String addEventFieldWithPersonYesNo(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldWithPersonYesNo;
  static String addEventFieldWithPerson(BuildContext context) =>
      AppLocalizations.of(context)!.addEventFieldWithPerson;
  static String addEventSaveButton(BuildContext context) =>
      AppLocalizations.of(context)!.addEventSaveButton;

  // Upcoming Event Card Strings (display only)
  static String upcomingEventDatePrefix(BuildContext context) =>
      AppLocalizations.of(context)!.upcomingEventDatePrefix;
  static String upcomingEventPriorityPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.upcomingEventPriorityPrefix;
  static String upcomingEventDescriptionPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.upcomingEventDescriptionPrefix;

  // Monthly Calendar Strings (display only)
  static String monthlyCalendarMondayAbbr(BuildContext context) =>
      AppLocalizations.of(context)!.monthlyCalendarMondayAbbr;
  static String monthlyCalendarTuesdayAbbr(BuildContext context) =>
      AppLocalizations.of(context)!.monthlyCalendarTuesdayAbbr;
  static String monthlyCalendarWednesdayAbbr(BuildContext context) =>
      AppLocalizations.of(context)!.monthlyCalendarWednesdayAbbr;
  static String monthlyCalendarThursdayAbbr(BuildContext context) =>
      AppLocalizations.of(context)!.monthlyCalendarThursdayAbbr;
  static String monthlyCalendarFridayAbbr(BuildContext context) =>
      AppLocalizations.of(context)!.monthlyCalendarFridayAbbr;
  static String monthlyCalendarSaturdayAbbr(BuildContext context) =>
      AppLocalizations.of(context)!.monthlyCalendarSaturdayAbbr;
  static String monthlyCalendarSundayAbbr(BuildContext context) =>
      AppLocalizations.of(context)!.monthlyCalendarSundayAbbr;
  static String monthlyCalendarEventsForMonthPrefix(BuildContext context) =>
      AppLocalizations.of(context)!.monthlyCalendarEventsForMonthPrefix;
  static String monthlyCalendarNoEventsForMonth(BuildContext context) =>
      AppLocalizations.of(context)!.monthlyCalendarNoEventsForMonth;

  // Month Row Strings (display only)
  static String monthJanuary(BuildContext context) =>
      AppLocalizations.of(context)!.monthJanuary;
  static String monthFebruary(BuildContext context) =>
      AppLocalizations.of(context)!.monthFebruary;
  static String monthMarch(BuildContext context) =>
      AppLocalizations.of(context)!.monthMarch;
  static String monthApril(BuildContext context) =>
      AppLocalizations.of(context)!.monthApril;
  static String monthMay(BuildContext context) =>
      AppLocalizations.of(context)!.monthMay;
  static String monthJune(BuildContext context) =>
      AppLocalizations.of(context)!.monthJune;
  static String monthJuly(BuildContext context) =>
      AppLocalizations.of(context)!.monthJuly;
  static String monthAugust(BuildContext context) =>
      AppLocalizations.of(context)!.monthAugust;
  static String monthSeptember(BuildContext context) =>
      AppLocalizations.of(context)!.monthSeptember;
  static String monthOctober(BuildContext context) =>
      AppLocalizations.of(context)!.monthOctober;
  static String monthNovember(BuildContext context) =>
      AppLocalizations.of(context)!.monthNovember;
  static String monthDecember(BuildContext context) =>
      AppLocalizations.of(context)!.monthDecember;

  // Footer Strings (display only)
  static String footerReturnToCurrentMonthTooltip(BuildContext context) =>
      AppLocalizations.of(context)!.footerReturnToCurrentMonthTooltip;

  // Profile Button Strings (display only)
  static String profileButtonTooltip(BuildContext context) =>
      AppLocalizations.of(context)!.profileButtonTooltip;

  // Chat Button Strings (display only)
  static String chatButtonTooltip(BuildContext context) =>
      AppLocalizations.of(context)!.chatButtonTooltip;

  // Calendar Toggle Button Strings (display only)
  static String calendarToggleShowYearlyViewTooltip(BuildContext context) =>
      AppLocalizations.of(context)!.calendarToggleShowYearlyViewTooltip;
  static String calendarToggleShowMonthlyViewTooltip(BuildContext context) =>
      AppLocalizations.of(context)!.calendarToggleShowMonthlyViewTooltip;

  // Priority Display Names (Capitalized for display)
  static String priorityDisplayCritical(BuildContext context) =>
      AppLocalizations.of(context)!.priorityDisplayCritical;
  static String priorityDisplayHigh(BuildContext context) =>
      AppLocalizations.of(context)!.priorityDisplayHigh;
  static String priorityDisplayMedium(BuildContext context) =>
      AppLocalizations.of(context)!.priorityDisplayMedium;
  static String priorityDisplayLow(BuildContext context) =>
      AppLocalizations.of(context)!.priorityDisplayLow;

  // SignUpScreen display strings
  static String signUpCreateAccountTitle(BuildContext context) =>
      AppLocalizations.of(context)!.signUpCreateAccountTitle;
  static String signUpLogInText(BuildContext context) =>
      AppLocalizations.of(context)!.signUpLogInText;
  static String signUpSubtitleText(BuildContext context) =>
      AppLocalizations.of(context)!.signUpSubtitleText;
  static String signUpEmailHint(BuildContext context) =>
      AppLocalizations.of(context)!.signUpEmailHint;
  static String signUpUsernameHint(BuildContext context) =>
      AppLocalizations.of(context)!.signUpUsernameHint;
  static String signUpPasswordHint(BuildContext context) =>
      AppLocalizations.of(context)!.signUpPasswordHint;
  static String signUpConfirmPasswordHint(BuildContext context) =>
      AppLocalizations.of(context)!.signUpConfirmPasswordHint;
  static String signUpGetStartedButton(BuildContext context) =>
      AppLocalizations.of(context)!.signUpGetStartedButton;
  static String signUpOrSignUpWith(BuildContext context) =>
      AppLocalizations.of(context)!.signUpOrSignUpWith;

  // SignInScreen display strings
  static String signInCreateAccountText(BuildContext context) =>
      AppLocalizations.of(context)!.signInCreateAccountText;
  static String signInLogInText(BuildContext context) =>
      AppLocalizations.of(context)!.signInLogInText;
  static String signInWelcomeTitle(BuildContext context) =>
      AppLocalizations.of(context)!.signInWelcomeTitle;
  static String signInSubtitle(BuildContext context) =>
      AppLocalizations.of(context)!.signInSubtitle;
  static String signInEmailHint(BuildContext context) =>
      AppLocalizations.of(context)!.signInEmailHint;
  static String signInPasswordHint(BuildContext context) =>
      AppLocalizations.of(context)!.signInPasswordHint;
  static String signInButtonText(BuildContext context) =>
      AppLocalizations.of(context)!.signInButtonText;
  static String signInOrSignInWith(BuildContext context) =>
      AppLocalizations.of(context)!.signInOrSignInWith;
  static String signInTitle(BuildContext context) =>
      AppLocalizations.of(context)!.signInTitle;
  static String emailLabel(BuildContext context) =>
      AppLocalizations.of(context)!.emailLabel;
  static String passwordLabel(BuildContext context) =>
      AppLocalizations.of(context)!.passwordLabel;
  static String loginFailed(BuildContext context) =>
      AppLocalizations.of(context)!.loginFailed;
  static String welcomeBack(BuildContext context) =>
      AppLocalizations.of(context)!.welcomeBack;
  static String createAccount(BuildContext context) =>
      AppLocalizations.of(context)!.createAccount;
  static String logIn(BuildContext context) =>
      AppLocalizations.of(context)!.logIn;
  static String orSignInWith(BuildContext context) =>
      AppLocalizations.of(context)!.orSignInWith;
  static String signInCredentialsFailed(BuildContext context) =>
      AppLocalizations.of(context)!.signInCredentialsFailed;
  static String signInFailed(BuildContext context) =>
      AppLocalizations.of(context)!.signInFailed;

  // SocialSignInButtons display strings
  static String socialSignInGoogleText(BuildContext context) =>
      AppLocalizations.of(context)!.socialSignInGoogleText;
  static String socialSignInAppleText(BuildContext context) =>
      AppLocalizations.of(context)!.socialSignInAppleText;

  // EventifyAuthLayout display strings
  static String appTitleEventify(BuildContext context) =>
      AppLocalizations.of(context)!.appTitleEventify;

  // ForgotPasswordOption display strings
  static String forgotPasswordOptionText(BuildContext context) =>
      AppLocalizations.of(context)!.forgotPasswordOptionText;
  static String forgotPasswordDialogSendButton(BuildContext context) =>
      AppLocalizations.of(context)!.forgotPasswordDialogSendButton;
  static String forgotPasswordDialogCancelButton(BuildContext context) =>
      AppLocalizations.of(context)!.forgotPasswordDialogCancelButton;
  static String forgotPasswordDialogSuccess(BuildContext context) =>
      AppLocalizations.of(context)!.forgotPasswordDialogSuccess;

  // Password requirements string
  static String passwordRequirementsNotMet(BuildContext context) =>
      AppLocalizations.of(context)!.passwordRequirementsNotMet;
  static String passwordSaved(BuildContext context) =>
      AppLocalizations.of(context)!.passwordSaved;
  static String passwordRequired(BuildContext context) =>
      AppLocalizations.of(context)!.passwordRequired;
  static String passwordResetError(BuildContext context) =>
      AppLocalizations.of(context)!.passwordResetError;

  // Error log messages for AuthRemoteDataSource
  static String firebaseAuthRegisterError(BuildContext context) =>
      AppLocalizations.of(context)!.firebaseAuthRegisterError;
  static String unexpectedRegisterError(BuildContext context) =>
      AppLocalizations.of(context)!.unexpectedRegisterError;
  static String firestoreSaveUserError(BuildContext context) =>
      AppLocalizations.of(context)!.firestoreSaveUserError;
  static String firebaseAuthLoginError(BuildContext context) =>
      AppLocalizations.of(context)!.firebaseAuthLoginError;
  static String unexpectedLoginError(BuildContext context) =>
      AppLocalizations.of(context)!.unexpectedLoginError;
  static String errorSavingGoogleUserInfo(BuildContext context) =>
      AppLocalizations.of(context)!.errorSavingGoogleUserInfo;
  static String firebaseAuthResetPasswordError(BuildContext context) =>
      AppLocalizations.of(context)!.firebaseAuthResetPasswordError;
  static String unexpectedResetPasswordError(BuildContext context) =>
      AppLocalizations.of(context)!.unexpectedResetPasswordError;
}
