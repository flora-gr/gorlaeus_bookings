import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingDataSource extends DataGridSource {
  BookingDataSource(
    this.roomsOverview,
    this.timeIfToday, {
    required this.onEmailButtonClicked,
    required this.context,
  }) {
    _bookingData = roomsOverview.keys
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

  final Map<String, Iterable<TimeBlock?>> roomsOverview;
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
          final bool isFree = !roomsOverview[room]!.any(
              (TimeBlock? time) => time?.overlapsWith(bookingTime) == true);
          final bool isPast = timeIfToday != null &&
              TimeBlock(startTime: timeIfToday!, endTime: timeIfToday!)
                  .isAfter(bookingTime);
          return InkWell(
            onTap: () => _showBookingDialog(
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
    if (isPast) {
      return isFree
          ? Styles.freeRoomEarlierColor
          : Styles.bookedRoomEarlierColor;
    } else {
      return isFree ? Styles.freeRoomColor : Styles.bookedRoomColor;
    }
  }

  void _showBookingDialog({
    required String room,
    required String time,
    required bool isFree,
    required bool isPast,
  }) {
    showDialog(
      builder: (_) => AlertDialog(
        title: Text(
          isPast
              ? Strings.bookingTimePastDialogTitle
              : isFree
                  ? Strings.roomFreeDialogHeader
                  : Strings.roomBookedDialogHeader,
        ),
        content: Text(
          isPast
              ? Strings.bookingTimePastDialogText
              : isFree
                  ? Strings.roomFreeDialogText(room, time)
                  : Strings.roomBookedDialogText,
        ),
        actions: !isPast && isFree
            ? <Widget>[
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
              ]
            : null,
      ),
      context: context,
    );
  }
}
