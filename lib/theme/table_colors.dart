import 'package:flutter/material.dart';

abstract class TableColors extends ThemeExtension<TableColors> {
  Color get freeRoomColor;

  Color get bookedRoomColor;

  Color get freeRoomEarlierColor;

  Color get bookedRoomEarlierColor;

  @override
  ThemeExtension<TableColors> copyWith() {
    return this;
  }

  @override
  ThemeExtension<TableColors> lerp(
      ThemeExtension<TableColors>? other, double t) {
    return this;
  }
}

class TableColorsLight extends TableColors {
  TableColorsLight();

  @override
  Color freeRoomColor = Colors.lightGreen;

  @override
  Color bookedRoomColor = const Color(0xFFF08080);

  @override
  Color freeRoomEarlierColor = const Color(0xFF889973);

  @override
  Color bookedRoomEarlierColor = const Color(0xFFA38888);
}

class TableColorsDark extends TableColors {
  TableColorsDark();

  @override
  Color get freeRoomColor => const Color(0xFF466225);

  @override
  Color get bookedRoomColor => const Color(0xFF784040);

  @override
  Color get freeRoomEarlierColor => const Color(0xFF1C270F);

  @override
  Color get bookedRoomEarlierColor => const Color(0xFF301A1A);
}
