import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'theme.dart';

void main() => runApp(const TripPlanApp());

class TripPlanApp extends StatefulWidget {
  const TripPlanApp({super.key});
  @override
  State<TripPlanApp> createState() => _TripPlanAppState();
}

class _TripPlanAppState extends State<TripPlanApp> {
  ThemeMode _mode = ThemeMode.dark;

  void toggleTheme() => setState(() => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripPlan',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: _mode,
      home: LoginPage(onToggleTheme: toggleTheme),
    );
  }
}
