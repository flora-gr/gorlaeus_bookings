import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

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
    final List<String> timeStringSplit = split(':');
    if (timeStringSplit.length == 2) {
      final int? hour = int.tryParse(timeStringSplit[0]);
      final int? minute = int.tryParse(timeStringSplit[1]);
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

  String toRoomName() {
    if (Rooms.cRooms.contains(this)) {
      return replaceAll('0', 'C');
    } else if (this == Rooms.room13) {
      return 'Atrium*';
    } else if (this == Rooms.room21) {
      return 'Entrance Hall*';
    } else if (this == Rooms.room22) {
      return 'Sitter';
    } else if (Rooms.building3.contains(this)) {
      return 'HUY $this';
    }
    return this;
  }

  String toLongRoomName() {
    if (this == Rooms.room13) {
      return 'the Atrium of the Gorlaeus building';
    } else if (this == Rooms.room21) {
      return 'the Entrance Hall of the Gorlaeus Schotel';
    } else if (this == Rooms.room16) {
      return 'the Havingazaal of the Gorlaeus';
    } else if (this == Rooms.room22) {
      return 'the Sitterzaal in the Huygens building';
    } else if (Rooms.building3.contains(this)) {
      return 'Huygens room $this';
    } else {
      return 'room ${toRoomName()} of the Gorlaeus';
    }
  }

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  T? toEnum<T>(List<T> values) {
    return values.firstWhereOrNull(
      (T e) => e.toString().toLowerCase().split('.').last == toLowerCase(),
    );
  }
}
