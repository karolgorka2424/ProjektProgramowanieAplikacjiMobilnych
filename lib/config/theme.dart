import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color palette
class AppColors {
  // Light theme
  static const Color primaryLight = Color(0xFF007AFF);
  static const Color accentLight = Color(0xFF5AC8FA);
  static const Color backgroundLight = Color(0xFFF9F9F9);
  static const Color cardLight = Colors.white;
  static const Color textDarkLight = Color(0xFF333333);
  static const Color textLightLight = Color(0xFF666666);
  static const Color dividerLight = Color(0xFFDDDDDD);

  // Dark theme
  static const Color primaryDark = Color(0xFF0A84FF);
  static const Color accentDark = Color(0xFF64D2FF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textDarkDark = Colors.white;
  static const Color textLightDark = Color(0xFFBBBBBB);
  static const Color dividerDark = Color(0xFF2C2C2C);

  // Shared colors
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF5AC8FA);

  // Message bubbles
  static const Color sentMessageBubbleLight = Color(0xFF007AFF);
  static const Color sentMessageTextLight = Colors.white;
  static const Color receivedMessageBubbleLight = Color(0xFFE5E5EA);
  static const Color receivedMessageTextLight = Color(0xFF333333);

  static const Color sentMessageBubbleDark = Color(0xFF0A84FF);
  static const Color sentMessageTextDark = Colors.white;
  static const Color receivedMessageBubbleDark = Color(0xFF2C2C2E);
  static const Color receivedMessageTextDark = Colors.white;
}

// Light theme
ThemeData getLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      secondary: AppColors.accentLight,
      onSecondary: Colors.white,
      error: AppColors.error,
      background: AppColors.backgroundLight,
      onBackground: AppColors.textDarkLight,
      surface: AppColors.cardLight,
      onSurface: AppColors.textDarkLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    dividerColor: AppColors.dividerLight,
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textLightLight,
      elevation: 8,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryLight,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

// Dark theme
ThemeData getDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: Colors.white,
      secondary: AppColors.accentDark,
      onSecondary: Colors.white,
      error: AppColors.error,
      background: AppColors.backgroundDark,
      onBackground: AppColors.textDarkDark,
      surface: AppColors.cardDark,
      onSurface: AppColors.textDarkDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    dividerColor: AppColors.dividerDark,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cardDark,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardDark,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.textLightDark,
      elevation: 8,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.dividerDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.dividerDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryDark,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}