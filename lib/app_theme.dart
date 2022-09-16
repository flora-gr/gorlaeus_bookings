import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData themeDataLight = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Styles.primaryColorSwatch,
    ).copyWith(
      secondary: Styles.secondaryColorSwatch,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide().copyWith(
          color: Styles.outlinedButtonBorderColor,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Styles.secondaryColorSwatch,
      ),
    ),
    textTheme: textTheme,
    scaffoldBackgroundColor: Styles.backgroundColor,
  );

  static final TextTheme textTheme = const TextTheme().copyWith(
    headline6: const TextStyle(
      color: Styles.primaryColorSwatch,
    ),
    subtitle1: TextStyle(
      height: Styles.defaultFontHeight,
    ),
    bodyText2: TextStyle(
      fontSize: Styles.defaultFontSize,
      height: Styles.defaultFontHeight,
    ),
  );
}
