import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';

extension StringExtension on String {
  TimeBlock? toTimeBlock() {
    if (length == 11) {
      String startTime = substring(0, 5);
      String endTime = substring(6);
      return TimeBlock(
        startTime: startTime.toTimeOfDay(),
        endTime: endTime.toTimeOfDay(),
      );
    }
    return null;
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(
      hour: int.parse(split(':')[0]),
      minute: int.parse(split(':')[1]),
    );
  }
}
