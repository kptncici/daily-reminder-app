import 'package:flutter/material.dart';

enum AppThemeColor {
  teal,
  blue,
  purple,
  orange,
  red,
}

MaterialColor getMaterialColor(
  AppThemeColor color,
) {
  switch (color) {
    case AppThemeColor.teal:
      return Colors.teal;

    case AppThemeColor.blue:
      return Colors.blue;

    case AppThemeColor.purple:
      return Colors.deepPurple;

    case AppThemeColor.orange:
      return Colors.orange;

    case AppThemeColor.red:
      return Colors.red;
  }
}

ThemeData getThemeData(
  MaterialColor color,
) {
  return ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor:
        const Color(0xFFF5F7FB),

    colorScheme: ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.light,
    ),

    // 🔥 APPBAR
    appBarTheme: AppBarTheme(
      backgroundColor: color,
      foregroundColor: Colors.white,

      elevation: 0,

      centerTitle: false,

      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // 🔥 CARD
    cardTheme: CardThemeData(
      color: Colors.white,

      elevation: 8,

      shadowColor:
          Colors.black.withOpacity(0.08),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(24),
      ),
    ),

    // 🔥 INPUT
    inputDecorationTheme:
        InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      hintStyle: TextStyle(
        color: Colors.grey.shade500,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide(
          color: color,
          width: 2,
        ),
      ),
    ),

    // 🔥 FLOATING BUTTON
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(
      backgroundColor: color,
      foregroundColor: Colors.white,

      elevation: 10,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
    ),

    // 🔥 ELEVATED BUTTON
    elevatedButtonTheme:
        ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,

        elevation: 8,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // 🔥 TEXT BUTTON
    textButtonTheme:
        TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color,
      ),
    ),

    // 🔥 SNACKBAR
    snackBarTheme: SnackBarThemeData(
      backgroundColor: color,

      behavior: SnackBarBehavior.floating,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      contentTextStyle:
          const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),

    // 🔥 DIALOG
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,

      elevation: 10,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(24),
      ),
    ),

    // 🔥 FONT
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
      ),

      headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
      ),

      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
      ),
    ),
  );
}