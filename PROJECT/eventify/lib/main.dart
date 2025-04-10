import 'package:eventify/src/widgets/log/login/signin_screen.dart' show SignInScreen;
import 'package:flutter/material.dart';
// import 'sign_up_screen.dart'; // Alternativamente, inicia en registro

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
      home: const SignInScreen(),
    );
  }
}
