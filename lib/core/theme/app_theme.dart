import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Color Palette
  static const Color primaryColor = Color(0xFF114733);
  static const Color secondaryDarkGray = Color(0xFF333C40);
  static const Color backgroundOffWhite = Color(0xFFF8F9FA);
  static const Color white = Colors.white;

  // Neutral/Grey tokens for cards and dividers
  static const Color neutralSurface = Color(0xFFF5F5F5);
  static const Color neutralText = Color(0xFF6B6B6B);
  static const Color neutralDivider = Color(0xFFD4D4D4);
  static const Color textMain = Colors.black;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundOffWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryDarkGray,
        surface: white,
        error: Colors.red,
        onSurface: textMain,
        onSurfaceVariant: neutralText,
        outlineVariant: neutralDivider,
        surfaceContainerHigh: neutralSurface, // using surfaceContainerHigh for the grey boxed areas
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundOffWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: secondaryDarkGray),
        titleTextStyle: TextStyle(
          color: secondaryDarkGray,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Typography Scale overrides
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textMain,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textMain,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textMain,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textMain,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: neutralText,
        ),
      ),
      dividerTheme: const DividerThemeData(color: neutralDivider, thickness: 1),
    );
  }
}
