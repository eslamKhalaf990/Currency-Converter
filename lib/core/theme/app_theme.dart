import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryRed = Color(0xFFCB1214);
  static const Color secondaryDarkGray = Color(0xFF333C40);
  static const Color backgroundOffWhite = Color(0xFFF8F9FA);
  static const Color white = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryRed,
      scaffoldBackgroundColor: backgroundOffWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        secondary: secondaryDarkGray,
        surface: white,
        error: primaryRed,
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
    );
  }
}
