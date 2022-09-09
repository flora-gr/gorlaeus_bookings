import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';

extension TimeBlockExtension on TimeBlock {
  String asString() {
    return '${startTimeString()}'
        ' - '
        '${_makePaddedString(endTime.hour)}:${_makePaddedString(endTime.minute)}';
  }

  String startTimeString() {
    return '${_makePaddedString(startTime.hour)}:${_makePaddedString(startTime.minute)}';
  }

  String _makePaddedString(int i) {
    return i.toString().padLeft(2, '0');
  }

  bool overlapsWith(TimeBlock bookingTime) {
    final int startTimeMinutes = _getMinutes(startTime);
    final int endTimeMinutes = _getMinutes(endTime);
    final int bookingStartTimeMinutes = _getMinutes(bookingTime.startTime);
    final int bookingEndTimeMinutes = _getMinutes(bookingTime.endTime);
    return startTimeMinutes >= bookingStartTimeMinutes &&
            startTimeMinutes < bookingEndTimeMinutes ||
        endTimeMinutes > bookingStartTimeMinutes &&
            endTimeMinutes <= bookingEndTimeMinutes ||
        startTimeMinutes <= bookingStartTimeMinutes &&
            endTimeMinutes >= bookingEndTimeMinutes;
  }

  bool isAfter(TimeBlock bookingTime) {
    final int startTimeMinutes = _getMinutes(startTime);
    final int bookingEndTimeMinutes = _getMinutes(bookingTime.endTime);
    return startTimeMinutes >= bookingEndTimeMinutes;
  }

  int _getMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }
}
