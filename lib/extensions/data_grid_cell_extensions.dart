import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Only applies to data grid cells belonging to booking table / booking data source
extension DataGridCellExtensions on DataGridCell {
  String room() {
    return value as String;
  }

  TimeBlock bookingTime() {
    return BookingTimes.all.singleWhere(
        (TimeBlock bookingTime) => bookingTime.startTimeString() == columnName);
  }

  bool isPast(TimeOfDay? timeIfToday) {
    return timeIfToday != null &&
        TimeBlock(startTime: timeIfToday, endTime: timeIfToday)
            .isAfter(bookingTime());
  }
}
