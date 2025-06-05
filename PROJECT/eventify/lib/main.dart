import 'package:eventify/auth/presentation/screen/login/sign_in_screen.dart';
import 'package:eventify/auth/presentation/screen/profile/profile_screen.dart';
import 'package:eventify/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:eventify/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:eventify/calendar/presentation/screen/calendar/calendar_screen.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/chat/presentation/screen/chat_screen.dart';
import 'package:eventify/chat/presentation/view_model/chat_view_model.dart';
import 'package:eventify/common/constants/app_internal_constants.dart';
import 'package:eventify/common/constants/app_localizations_constants.dart';
import 'package:eventify/common/theme/colors/app_colors.dart';
import 'package:eventify/common/widgets/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'di/service_locator.dart' as di;
import 'firebase_options.dart';

// Función principal que inicializa la app y sus dependencias
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init(); // Inyección de dependencias
  await AppColors.loadThemeColor();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeDateFormatting().then((_) => runApp(const MyApp()));
}

// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _emptyLocale = '';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ViewModels
        ChangeNotifierProvider(create: (_) => di.sl<SignInViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<SignUpViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<EventViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<ChatViewModel>()),
      ],
      child: MaterialApp(
        title: AppInternalConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.dark().copyWith(
            primary: AppColors.primary,
            secondary: AppColors.accentColor400,
            brightness: Brightness.dark,
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: AppColors.textBody2Grey),
            filled: true,
            fillColor: AppColors.inputFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.elevatedButtonForeground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.outlinedButtonBorder),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: AppColors.textPrimary),
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale(AppLocalizationsConstants.en, _emptyLocale),
          Locale(AppLocalizationsConstants.es, _emptyLocale),
          Locale(AppLocalizationsConstants.fr, _emptyLocale),
          Locale(AppLocalizationsConstants.zh, _emptyLocale),
          Locale(AppLocalizationsConstants.ar, _emptyLocale),
        ],
        home: const SplashScreen(),
        routes: {
          CalendarScreen.routeName: (context) => const CalendarScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          SignInScreen.routeName: (context) => const SignInScreen(),
        },
        navigatorObservers: [routeObserver],
      ),
    );
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
