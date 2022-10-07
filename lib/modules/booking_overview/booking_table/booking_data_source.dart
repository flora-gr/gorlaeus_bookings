import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/extensions/data_grid_cell_extensions.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/theme/styles.dart';
import 'package:gorlaeus_bookings/theme/table_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingDataSource extends DataGridSource {
  BookingDataSource(
    this.bookingsPerRoom,
    this.timeIfToday, {
    required this.context,
  }) {
    _bookingData = bookingsPerRoom.keys
        .map(
          (String room) => DataGridRow(
            cells: BookingTimes.all
                .map(
                  (TimeBlock bookingTime) => DataGridCell(
                    columnName: bookingTime.startTimeString(),
                    value: room,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  final Map<String, Iterable<BookingEntry?>> bookingsPerRoom;
  final TimeOfDay? timeIfToday;
  final BuildContext context;

  late List<DataGridRow> _bookingData;

  @override
  List<DataGridRow> get rows => _bookingData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (DataGridCell cell) {
          final String room = cell.room();
          final Iterable<BookingEntry?> bookings = bookingsPerRoom[room]!.where(
              (BookingEntry? booking) =>
                  booking?.time?.overlapsWith(cell.bookingTime()) == true);
          final bool isFree = bookings.isEmpty;
          final String? freeTime =
              isFree ? cell.freeTime(bookingsPerRoom) : null;
          final bool isPast = cell.isPast(timeIfToday);
          return InkWell(
            onTap: () => _showBookingDialog(
              bookings: bookings,
              room: room.toLongRoomName(),
              time: cell.columnName,
              freeTime: freeTime,
              isFree: isFree,
              isPast: isPast,
            ),
            child: Container(
              color: _getCellColor(isFree: isFree, isPast: isPast),
              alignment: Alignment.centerLeft,
              padding: Styles.padding8,
              child: Text(room.toRoomName()),
            ),
          );
        },
      ).toList(),
    );
  }

  Color _getCellColor({
    required bool isFree,
    required bool isPast,
  }) {
    final TableColors tableColors = Theme.of(context).extension<TableColors>()!;
    if (isPast) {
      return isFree
          ? tableColors.freeRoomEarlierColor
          : tableColors.bookedRoomEarlierColor;
    } else {
      return isFree ? tableColors.freeRoomColor : tableColors.bookedRoomColor;
    }
  }

  void _showBookingDialog({
    required Iterable<BookingEntry?> bookings,
    required String room,
    required String time,
    required String? freeTime,
    required bool isFree,
    required bool isPast,
  }) {
    showDialog(
      builder: (_) => AlertDialog(
        title: Text(
          isFree
              ? isPast
                  ? Strings.roomFreeInPastDialogTitle
                  : Strings.roomFreeDialogTitle
              : Strings.roomBookedDialogTitle,
        ),
        content: Text(
          isFree
              ? isPast
                  ? Strings.roomFreeInPastDialogText
                  : Strings.roomFreeDialogText(room.capitalize(), freeTime!)
              : _getRoomBookedText(
                  room: room,
                  isPast: isPast,
                  bookings: bookings,
                ),
        ),
        actions: <Widget>[
          if (!isPast && isFree) ...<Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(Strings.okButton),
            ),
          ] else
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.okButton),
            ),
        ],
      ),
      context: context,
    );
  }

  String _getRoomBookedText({
    required String room,
    required bool isPast,
    required Iterable<BookingEntry?> bookings,
  }) {
    final List<BookingEntry?> uniqueBookings = bookings.toSet().toList();
    String? additionalBookings;
    if (uniqueBookings.length > 1) {
      additionalBookings = '';
      uniqueBookings.forEachIndexed((int i, BookingEntry? booking) {
        if (i != 0) {
          String additionalBooking = Strings.additionalBookingDialogText(
            user: booking!.user,
            activity: booking.activity,
            timeBlock: booking.time!.asString(),
          );
          additionalBookings = additionalBookings! + additionalBooking;
        }
      });
    }

    return Strings.roomBookedDialogText(
      room: room.capitalize(),
      isPast: isPast,
      user: uniqueBookings.first!.user,
      activity: uniqueBookings.first!.activity,
      timeBlock: uniqueBookings.first!.time!.asString(),
      additionalBookings: additionalBookings,
    );
  }
}
