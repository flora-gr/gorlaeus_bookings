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
    textTheme: textTheme(Styles.primaryColorSwatch),
    scaffoldBackgroundColor: Styles.backgroundColor,
  );

  static final ThemeData themeDataDark = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: Styles.primaryColorSwatchDark,
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
    textTheme: textTheme(Styles.primaryColorSwatchDark),
  );

  static TextTheme textTheme(Color headline6Color) =>
      const TextTheme().copyWith(
        headline6: TextStyle(
          color: headline6Color,
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
