import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  int asMinutes() {
    return hour * 60 + minute;
  }

  bool isAfter(TimeOfDay time) {
    return asMinutes() >= time.asMinutes();
  }
}
