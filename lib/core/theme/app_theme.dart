import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Color Palette - Light
  static const Color primaryColor = Color(0xFF114733);
  static const Color secondaryDarkGray = Color(0xFF333C40);
  static const Color backgroundOffWhite = Color(0xFFF8F9FA);
  static const Color white = Colors.white;

  // Neutral/Grey tokens for cards and dividers - Light
  static const Color neutralSurface = Color(0xFFF5F5F5);
  static const Color neutralText = Color(0xFF6B6B6B);
  static const Color neutralDivider = Color(0xFFD4D4D4);
  static const Color textMain = Colors.black;

  // Color Palette - Dark
  static const Color primaryColorDark = Color(0xFF1C7A58); 
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Neutral/Grey tokens - Dark
  static const Color neutralSurfaceDark = Color(0xFF2C2C2C);
  static const Color neutralTextDark = Color(0xFFAAAAAA);
  static const Color neutralDividerDark = Color(0xFF3A3A3A);
  static const Color textMainDark = Colors.white;

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
        surfaceContainerHigh: neutralSurface,
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
      navigationBarTheme: NavigationBarThemeData(
        height: 65,
        backgroundColor: white,
        indicatorColor: primaryColor.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColor);
          }
          return const IconThemeData(color: neutralText);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 13);
          }
          return const TextStyle(color: neutralText, fontWeight: FontWeight.w500, fontSize: 13);
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryColor;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return textMain;
          }),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textMain),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textMain),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textMain),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textMain),
        bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: neutralText),
      ),
      dividerTheme: const DividerThemeData(color: neutralDivider, thickness: 1),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColorDark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColorDark,
        secondary: backgroundOffWhite,
        surface: surfaceDark,
        error: Colors.redAccent,
        onSurface: textMainDark,
        onSurfaceVariant: neutralTextDark,
        outlineVariant: neutralDividerDark,
        surfaceContainerHigh: neutralSurfaceDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        iconTheme: IconThemeData(color: backgroundOffWhite),
        titleTextStyle: TextStyle(
          color: textMainDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 65,
        backgroundColor: surfaceDark,
        indicatorColor: primaryColorDark.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColorDark);
          }
          return const IconThemeData(color: neutralTextDark);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: primaryColorDark, fontWeight: FontWeight.w600, fontSize: 13);
          }
          return const TextStyle(color: neutralTextDark, fontWeight: FontWeight.w500, fontSize: 13);
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryColorDark;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return textMainDark;
          }),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textMainDark),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textMainDark),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textMainDark),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textMainDark),
        bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: neutralTextDark),
      ),
      dividerTheme: const DividerThemeData(color: neutralDividerDark, thickness: 1),
    );
  }
}
