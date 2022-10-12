import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/theme/styles.dart';

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
        side: BorderSide(
          color: Styles.outlinedButtonBorderColor,
        ),
      ),
    ),
    scaffoldBackgroundColor: Styles.backgroundColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Styles.secondaryColorSwatch,
      ),
    ),
    textTheme: _textTheme(
      headline6Color: Styles.primaryColorSwatch,
    ),
  );

  static final ThemeData themeDataDark = ThemeData(
    appBarTheme: AppBarTheme(
      color: Styles.appBarColorDark,
      foregroundColor: Styles.textColorDark,
    ),
    canvasColor: Styles.canvasColorDark,
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) => Styles.appBarColorDark),
    ),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: Styles.primaryColorSwatchDark,
      accentColor: Styles.textColorDark,
    ).copyWith(
      surface: Styles.appBarColorDark,
      secondary: Styles.secondaryColorSwatchDark,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Styles.dialogBackgroundColorDark,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Styles.outlinedButtonBorderColorDark,
        ),
      ),
    ),
    scaffoldBackgroundColor: Styles.backgroundColorDark,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Styles.secondaryColorSwatchDark,
      ),
    ),
    textTheme: _textTheme(
      defaultColorOverride: Styles.textColorDark,
    ),
  );

  static TextTheme _textTheme({
    Color? headline6Color,
    Color? defaultColorOverride,
  }) =>
      TextTheme(
        headline6: TextStyle(
          color: headline6Color ?? defaultColorOverride,
        ),
        subtitle1: TextStyle(
          color: defaultColorOverride,
          height: Styles.defaultFontHeight,
        ),
        subtitle2: TextStyle(
          color: defaultColorOverride,
        ),
        bodyText2: TextStyle(
          color: defaultColorOverride,
          fontSize: Styles.defaultFontSize,
          height: Styles.defaultFontHeight,
        ),
      );
}
