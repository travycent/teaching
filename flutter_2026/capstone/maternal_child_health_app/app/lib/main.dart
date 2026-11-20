import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'services/seed_data.dart';
import 'widgets/app_background.dart';

void main() {
  seedDemoData();
  runApp(const MaternalHealthApp());
}

class MaternalHealthApp extends StatelessWidget {
  const MaternalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maternal and Child Health',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: const Color.fromARGB(255, 2, 3, 22),
        ),
      ),
      builder: (context, child) =>
          AppBackground(child: child ?? const SizedBox()),
      home: const WelcomeScreen(),
    );
  }
}
