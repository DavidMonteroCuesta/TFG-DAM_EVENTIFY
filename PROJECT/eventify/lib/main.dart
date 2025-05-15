import 'package:eventify/auth/presentation/screen/sign_in_screen.dart';
import 'package:eventify/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:eventify/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:eventify/calendar/presentation/screen/calendar_screen.dart';
import 'package:eventify/common/widgets/chat/widgets/chat_screen.dart';
import 'package:eventify/common/widgets/profile/widgets/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/service_locator.dart' as di;
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  await initializeDateFormatting('es_ES', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<SignInViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<SignUpViewModel>()),
      ],
      child: MaterialApp(
        title: 'Eventify Auth',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
            accentColor: Colors.greenAccent.shade400,
            brightness: Brightness.dark,
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: const Color(0xFF1F1F1F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade400,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        home: const CalendarScreen(),
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