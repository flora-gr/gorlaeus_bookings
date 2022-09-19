import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
    required this.onEmailButtonTapped,
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
      onEmailButtonTapped;
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
              time: cell.columnName,
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
                  ? Strings.roomFreeInPastDialogTitle
                  : Strings.roomFreeDialogTitle
              : Strings.roomBookedDialogTitle,
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
              child: const Text(Strings.cancelButton),
            ),
            TextButton(
              onPressed: () {
                onEmailButtonTapped(time: time, room: room);
                Navigator.of(context).pop();
              },
              child: const Text(Strings.yesBookRoomButton),
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
}
