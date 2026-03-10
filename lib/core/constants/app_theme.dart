import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0D0F14);
  static const Color surface = Color(0xFF141720);
  static const Color cardSurface = Color(0xFF1C2030);
  static const Color elevated = Color(0xFF232840);

  static const Color primary = Color(0xFF4F8EF7);
  static const Color accent = Color(0xFF00D4AA);
  static const Color warning = Color(0xFFFFC947);
  static const Color danger = Color(0xFFFF5F6D);
  static const Color success = Color(0xFF00C896);

  static const Color textPrimary = Color(0xFFF0F2FF);
  static const Color textSecondary = Color(0xFF8B93B0);
  static const Color textMuted = Color(0xFF4A5068);

  static const Color border = Color(0xFF252A3D);
  static const Color divider = Color(0xFF1E2235);

  static const Color white = Colors.white;
  static const Color onSurface = textPrimary;
  static const Color iconColorGrey = textSecondary;
  static const Color greyText = textMuted;
  static const Color darkLight = elevated;
  static const Color buttonColor = primary;
  static const Color searchField = cardSurface;
  static const Color screenTopColor = surface;
  static const Color screenTop2 = background;

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: surface,
      error: danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    cardTheme: CardThemeData(
      color: cardSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardSurface,
      hintStyle: const TextStyle(color: textMuted),
      labelStyle: const TextStyle(color: textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: danger, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: danger, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(background),
      side: const BorderSide(color: textSecondary, width: 1.5),
      shape: const CircleBorder(),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: elevated,
      contentTextStyle: TextStyle(color: textPrimary),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: textPrimary),
      bodySmall: TextStyle(color: textSecondary),
    ),
  );
}
