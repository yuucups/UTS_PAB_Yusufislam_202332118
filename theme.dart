import 'package:flutter/material.dart';

final _seed = Color(0xFF0A6B67);

ThemeData lightTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.light),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  cardColor: const Color(0xFFF6F9F8),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black87),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
  ),
);

ThemeData darkTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF0B1315),
  cardColor: const Color(0xFF0F1B1C),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF0F1B1C),
  ),
);
