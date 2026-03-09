import 'package:flutter/material.dart';

class AppTheme {
  static const Color white = Colors.white;

  static const Color primary = Color(0xFF1E6F9F);
  static const Color iconColorGrey = Color(0xFF747474);

  static const Color surface = Color(0xFF1A1A1A);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color screenTopColor = Color.fromARGB(255, 32, 32, 32);
  static const Color screenTop2 = Color(0xFF151515);
  static const Color searchField = Color.fromARGB(255, 39, 39, 39);
  static const Color greyText = Color.fromARGB(255, 94, 91, 91);

  static const Color darkLight = Color(0xFF353638);

  static const Color buttonColor = Color(0xFF276e9d);

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: surface,
    primaryColor: primary,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: onSurface)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
