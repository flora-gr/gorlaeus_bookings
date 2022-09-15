import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingDataSource extends DataGridSource {
  BookingDataSource(
    this.bookingsPerRoom,
    this.timeIfToday, {
    required this.onEmailButtonClicked,
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
  final void Function({required String time, required String room})
      onEmailButtonClicked;
  final BuildContext context;

  List<DataGridRow> _bookingData = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _bookingData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (DataGridCell cell) {
          final String room = cell.value as String;
          final TimeBlock bookingTime = BookingTimes.all.singleWhere(
              (TimeBlock bookingTime) =>
                  bookingTime.startTimeString() == cell.columnName);
          final BookingEntry? booking = bookingsPerRoom[room]!
              .singleWhereOrNull((BookingEntry? booking) =>
                  booking?.time?.overlapsWith(bookingTime) == true);
          final bool isFree = booking == null;
          final bool isPast = timeIfToday != null &&
              TimeBlock(startTime: timeIfToday!, endTime: timeIfToday!)
                  .isAfter(bookingTime);
          return InkWell(
            onTap: () => _showBookingDialog(
              booking: booking,
              room: room.toLongRoomName(),
              time: bookingTime.startTimeString(),
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
    if (isPast) {
      return isFree
          ? Styles.freeRoomEarlierColor
          : Styles.bookedRoomEarlierColor;
    } else {
      return isFree ? Styles.freeRoomColor : Styles.bookedRoomColor;
    }
  }

  void _showBookingDialog({
    required BookingEntry? booking,
    required String room,
    required String time,
    required bool isFree,
    required bool isPast,
  }) {
    showDialog(
      builder: (_) => AlertDialog(
        title: Text(
          isFree
              ? isPast
                  ? Strings.roomFreeInPastDialogHeader
                  : Strings.roomFreeDialogHeader
              : Strings.roomBookedDialogHeader,
        ),
        content: Text(
          isFree
              ? isPast
                  ? Strings.roomFreeInPastDialogText
                  : Strings.roomFreeDialogText(room, time)
              : Strings.roomBookedDialogText(
                  room.capitalize(),
                  isPast,
                  booking!.user,
                  booking.activity,
                  booking.time!.asString(),
                ),
        ),
        actions: <Widget>[
          if (!isPast && isFree) ...<Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () {
                onEmailButtonClicked(time: time, room: room);
                Navigator.of(context).pop();
              },
              child: const Text(Strings.yesBookRoom),
            ),
          ] else
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.ok),
            ),
        ],
      ),
      context: context,
    );
  }
}
