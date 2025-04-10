import 'package:eventify/src/widgets/calendar/months_screen.dart';
import 'package:eventify/src/widgets/log/login/sign_in_screen.dart' show SignInScreen;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventify Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: const MonthsScreen(),
    );
  }
}
