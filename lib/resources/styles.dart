import 'package:flutter/material.dart';

class Styles {
  Styles._();

  // Colors
  static const MaterialColor primaryColorSwatch = MaterialColor(
    0xFF001158,
    <int, Color>{
      50: Color(0xFF99a0bc),
      100: Color(0xFF66709b),
      200: Color(0xFF4d588a),
      300: Color(0xFF334179),
      400: Color(0xFF1a2969),
      500: Color(0xFF001158),
      600: Color(0xFF000f4f),
      700: Color(0xFF000e46),
      800: Color(0xFF000c3e),
      900: Color(0xFF000a35),
    },
  );

  static const MaterialColor secondaryColorSwatch = MaterialColor(
    0xFFf46e32,
    <int, Color>{
      50: Color(0xFFfbc5ad),
      100: Color(0xFFf8a884),
      200: Color(0xFFf79a70),
      300: Color(0xFFf68b5b),
      400: Color(0xFFf57d47),
      500: Color(0xFFf46e32),
      600: Color(0xFFdc632d),
      700: Color(0xFFc35828),
      800: Color(0xFFab4d23),
      900: Color(0xFF92421e),
    },
  );

  static Color? backgroundColor = Colors.grey[100];

  static Color? outlinedButtonBorderColor = primaryColorSwatch[200];

  static Color freeRoomColor = Colors.lightGreen;

  static const Color bookedRoomColor = Color(0xFFF08080);

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
  static double defaultFontSize = 14;
  static double defaultFontHeight = 1.3;
}
