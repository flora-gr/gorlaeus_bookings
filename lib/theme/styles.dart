import 'package:flutter/material.dart';

class Styles {
  Styles._();

  // Light mode colors
  static const MaterialColor primaryColorSwatch = MaterialColor(
    0xFF001158,
    <int, Color>{
      50: Color(0xFF99A0BC),
      100: Color(0xFF66709B),
      200: Color(0xFF4D588A),
      300: Color(0xFF334179),
      400: Color(0xFF1A2969),
      500: Color(0xFF001158),
      600: Color(0xFF000F4F),
      700: Color(0xFF000E46),
      800: Color(0xFF000C3E),
      900: Color(0xFF000A35),
    },
  );

  static const MaterialColor secondaryColorSwatch = MaterialColor(
    0xFFF46E32,
    <int, Color>{
      50: Color(0xFFFBC5AD),
      100: Color(0xFFF8A884),
      200: Color(0xFFF79A70),
      300: Color(0xFFF68B5b),
      400: Color(0xFFF57D47),
      500: Color(0xFFF46E32),
      600: Color(0xFFDC632D),
      700: Color(0xFFC35828),
      800: Color(0xFFAB4D23),
      900: Color(0xFF92421E),
    },
  );

  static Color backgroundColor = Colors.grey.shade100;
  static Color outlinedButtonBorderColor = primaryColorSwatch[200]!;

  // Dark mode colors
  static const MaterialColor primaryColorSwatchDark = MaterialColor(
    0xFFADA9BB,
    <int, Color>{
      50: Color(0xFF00092C),
      100: Color(0xFF000A35),
      200: Color(0xFF000C3E),
      300: Color(0xFF000E46),
      400: Color(0xFF000F4F),
      500: Color(0xFF001158),
      600: Color(0xFF1A2969),
      700: Color(0xFF334179),
      800: Color(0xFF4D588A),
      900: Color(0xFFADA9BB),
    },
  );

  static const MaterialColor secondaryColorSwatchDark = MaterialColor(
    0xFFF79A70,
    <int, Color>{
      50: Color(0xFF7A3719),
      100: Color(0xFF92421E),
      200: Color(0xFFAB4D23),
      300: Color(0xFFC35828),
      400: Color(0xFFDC632D),
      500: Color(0xFFF46E32),
      600: Color(0xFFF57D47),
      700: Color(0xFFF68B5B),
      800: Color(0xFFF79A70),
      900: Color(0xFFF8A884),
    },
  );

  static const Color backgroundColorDark = Color(0xFF1A2039);
  static const Color dialogBackgroundColorDark = Color(0xFF1A2035);
  static const Color appBarColorDark = Color(0xFF000723);
  static Color textColorDark = Colors.grey.shade50;
  static Color outlinedButtonBorderColorDark = primaryColorSwatchDark[900]!;

  // Paddings
  static const EdgeInsetsGeometry defaultPagePadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 20);
  static const EdgeInsetsGeometry padding16 = EdgeInsets.all(16);
  static const EdgeInsetsGeometry padding8 = EdgeInsets.all(8);
  static const EdgeInsetsGeometry verticalPadding8 =
      EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsetsGeometry topPadding12 = EdgeInsets.only(top: 12);
  static const EdgeInsetsGeometry leftPadding12 = EdgeInsets.only(left: 12);

  // Other
  static BorderRadius borderRadius = BorderRadius.circular(6);
  static const BoxConstraints defaultWidthConstraint =
      BoxConstraints(maxWidth: 600);
  static double defaultFontSize = 14;
  static double defaultFontHeight = 1.3;
}
