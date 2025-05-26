import 'package:eventify/auth/presentation/screen/sign_in_screen.dart';
import 'package:eventify/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:eventify/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:eventify/calendar/presentation/screen/calendar_screen.dart';
import 'package:eventify/calendar/presentation/view_model/event_view_model.dart';
import 'package:eventify/chat/presentation/screen/chat_screen.dart';
import 'package:eventify/chat/presentation/view_model/chat_view_model.dart';
import 'package:eventify/auth/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:eventify/common/theme/colors/colors.dart'; // Import AppColors
import 'di/service_locator.dart' as di;
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  await initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<SignInViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<SignUpViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<EventViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<ChatViewModel>()),
      ],
      child: MaterialApp(
        title: 'Eventify Auth',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background, // Using AppColors
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: AppColors.primary as MaterialColor, // Using AppColors
            accentColor: AppColors.accentColor400, // Using AppColors, keeping shade400
            brightness: Brightness.dark,
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: AppColors.textBody2Grey), // Using AppColors
            filled: true,
            fillColor: AppColors.inputFillColor, // Using AppColors
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor400, // Using AppColors, keeping shade400
              foregroundColor: AppColors.elevatedButtonForeground, // Using AppColors
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary, // Using AppColors
              side: const BorderSide(color: AppColors.outlinedButtonBorder), // Using AppColors
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: AppColors.textPrimary), // Using AppColors
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
        ],
        home: Builder(
          builder: (context) {
            final auth = FirebaseAuth.instance;
            final user = auth.currentUser;
            if (user != null) {
              return const CalendarScreen();
            } else {
              return const SignInScreen();
            }
          },
        ),
        routes: {
          CalendarScreen.routeName: (context) => const CalendarScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          SignInScreen.routeName: (context) => const SignInScreen(),
        },
      ),
    );
  }
}
