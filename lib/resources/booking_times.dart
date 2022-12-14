import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';

class BookingTimes {
  static const TimeBlock time1 = TimeBlock(
    startTime: TimeOfDay(hour: 9, minute: 0),
    endTime: TimeOfDay(hour: 10, minute: 0),
  );
  static const TimeBlock time2 = TimeBlock(
    startTime: TimeOfDay(hour: 10, minute: 0),
    endTime: TimeOfDay(hour: 11, minute: 0),
  );
  static const TimeBlock time3 = TimeBlock(
    startTime: TimeOfDay(hour: 11, minute: 0),
    endTime: TimeOfDay(hour: 12, minute: 0),
  );
  static const TimeBlock time4 = TimeBlock(
    startTime: TimeOfDay(hour: 12, minute: 0),
    endTime: TimeOfDay(hour: 13, minute: 0),
  );
  static const TimeBlock time5 = TimeBlock(
    startTime: TimeOfDay(hour: 13, minute: 0),
    endTime: TimeOfDay(hour: 14, minute: 0),
  );
  static const TimeBlock time6 = TimeBlock(
    startTime: TimeOfDay(hour: 14, minute: 0),
    endTime: TimeOfDay(hour: 15, minute: 0),
  );
  static const TimeBlock time7 = TimeBlock(
    startTime: TimeOfDay(hour: 15, minute: 0),
    endTime: TimeOfDay(hour: 16, minute: 0),
  );
  static const TimeBlock time8 = TimeBlock(
    startTime: TimeOfDay(hour: 16, minute: 0),
    endTime: TimeOfDay(hour: 17, minute: 0),
  );
  static const TimeBlock time9 = TimeBlock(
    startTime: TimeOfDay(hour: 17, minute: 0),
    endTime: TimeOfDay(hour: 18, minute: 0),
  );

  static const Iterable<TimeBlock> all = <TimeBlock>[
    time1,
    time2,
    time3,
    time4,
    time5,
    time6,
    time7,
    time8,
    time9,
  ];
}
