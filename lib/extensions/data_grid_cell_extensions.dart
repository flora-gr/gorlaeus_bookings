import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
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

  Iterable<BookingEntry?> bookings(
          Map<String, Iterable<BookingEntry?>> bookingsPerRoom) =>
      bookingsPerRoom[room()]!.where((BookingEntry? booking) =>
          booking?.time?.overlapsWith(bookingTime()) == true);

  String? freeTime(
    Map<String, Iterable<BookingEntry?>> bookingsPerRoom,
    BuildContext context,
  ) {
    final Iterable<BookingEntry?> bookingsForRoom = bookingsPerRoom[room()]!;
    final List<TimeBlock?> bookingTimeBlocksForRoom =
        bookingsForRoom.map((BookingEntry? entry) => entry?.time).sort();

    if (bookingTimeBlocksForRoom.isEmpty) {
      return AppLocalizations.of(context).allDay;
    } else {
      final TimeBlock? previousBooking =
          bookingTimeBlocksForRoom.lastWhereOrNull(
              ((TimeBlock? timeBlock) => bookingTime().isAfter(timeBlock!)));
      final TimeBlock? nextBooking = bookingTimeBlocksForRoom.firstWhereOrNull(
          ((TimeBlock? timeBlock) => timeBlock!.isAfter(bookingTime())));
      if (previousBooking == null) {
        return '${AppLocalizations.of(context).until} ${nextBooking!.startTimeString()}';
      } else if (nextBooking == null) {
        return '${AppLocalizations.of(context).from} ${previousBooking.endTimeString()}';
      } else {
        return '${AppLocalizations.of(context).fromTo} ${previousBooking.endTimeString()} - ${nextBooking.startTimeString()}';
      }
    }
  }

  bool isPast(TimeOfDay? timeIfToday) {
    return timeIfToday != null &&
        TimeBlock(startTime: timeIfToday, endTime: timeIfToday)
            .isAfter(bookingTime());
  }
}
