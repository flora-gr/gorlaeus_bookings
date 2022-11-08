import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

extension StringExtensions on String {
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

  String toRoomName(BuildContext context) {
    if (Rooms.cRooms.contains(this)) {
      return replaceAll('0', 'C');
    } else if (this == Rooms.room13) {
      return AppLocalizations.of(context).room13Name;
    } else if (this == Rooms.room21) {
      return AppLocalizations.of(context).room21Name;
    } else if (this == Rooms.room22) {
      return AppLocalizations.of(context).room22Name;
    } else if (Rooms.building3.contains(this)) {
      return AppLocalizations.of(context).roomBuilding3Name(this);
    }
    return this;
  }

  String toLongRoomName(BuildContext context) {
    if (this == Rooms.room13) {
      return AppLocalizations.of(context).room13LongName;
    } else if (this == Rooms.room16) {
      return AppLocalizations.of(context).room16LongName;
    } else if (this == Rooms.room21) {
      return AppLocalizations.of(context).room21LongName;
    } else if (this == Rooms.room22) {
      return AppLocalizations.of(context).room22LongName;
    } else if (Rooms.building3.contains(this)) {
      return AppLocalizations.of(context).roomBuilding3LongName(this);
    } else {
      return AppLocalizations.of(context)
          .otherRoomLongName(toRoomName(context));
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
