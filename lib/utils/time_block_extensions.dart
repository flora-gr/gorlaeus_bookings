import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';

extension TimeBlockExtension on TimeBlock {
  String asString() {
    return '${startDateString()}'
        ' - '
        '${_makePaddedString(endTime.hour)}:${_makePaddedString(endTime.minute)}';
  }

  String startDateString() {
    return '${_makePaddedString(startTime.hour)}:${_makePaddedString(startTime.minute)}';
  }

  String _makePaddedString(int i) {
    return i.toString().padLeft(2, '0');
  }

  bool overlapsWith(TimeBlock bookingTime) {
    final double startTimeMinutes = _getMinutes(startTime);
    final double endTimeMinutes = _getMinutes(endTime);
    final double bookingStartTimeMinutes = _getMinutes(bookingTime.startTime);
    final double bookingEndTimeMinutes = _getMinutes(bookingTime.endTime);
    return startTimeMinutes > bookingStartTimeMinutes &&
            startTimeMinutes < bookingEndTimeMinutes ||
        endTimeMinutes > bookingStartTimeMinutes &&
            endTimeMinutes < bookingEndTimeMinutes ||
        startTimeMinutes < bookingStartTimeMinutes &&
            endTimeMinutes > bookingEndTimeMinutes;
  }

  double _getMinutes(TimeOfDay time) {
    return time.hour + time.minute / 60.0;
  }
}
