import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';

extension StringExtension on String {
  TimeBlock? toTimeBlock() {
    if (length == 11) {
      TimeOfDay? startTime = substring(0, 5).toTimeOfDay();
      TimeOfDay? endTime = substring(6).toTimeOfDay();
      if (startTime != null && endTime != null) {
        return TimeBlock(
          startTime: startTime,
          endTime: endTime,
        );
      }
      return null;
    }
    return null;
  }

  TimeOfDay? toTimeOfDay() {
    if (split(':').length == 2) {
      final int? hour = int.tryParse(split(':')[0]);
      final int? minute = int.tryParse(split(':')[1]);
      if (hour != null && minute != null) {
        return TimeOfDay(
          hour: hour,
          minute: minute,
        );
      }
      return null;
    }
    return null;
  }
}
