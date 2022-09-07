import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingDataSource extends DataGridSource {
  BookingDataSource({
    required Map<String, Iterable<TimeBlock?>> bookings,
    required this.onEmailButtonClicked,
    required this.context,
  }) {
    _bookingData = bookings.keys
        .map(
          (String room) => DataGridRow(
            cells: BookingTimes.all
                .map(
                  (TimeBlock bookingTime) => DataGridCell(
                    value: bookings[room]!.any((TimeBlock? time) =>
                            time?.overlapsWith(bookingTime) == true)
                        ? '${room.toRoomName()}${Strings.booked}'
                        : '${room.toRoomName()}${Strings.free}',
                    columnName: bookingTime.startTimeString(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

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
          final bool isFree = cell.value.endsWith(Strings.free);
          final String? room =
              isFree ? cell.value!.replaceAll(Strings.free, '') : null;
          return InkWell(
            onTap: () => _showDialog(
              room: room,
              time: cell.columnName,
              isFree: isFree,
            ),
            child: Container(
              color: isFree ? Styles.freeRoomColor : Styles.bookedRoomColor,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cell.value
                    .replaceAll(Strings.free, '')
                    .replaceAll(Strings.booked, ''),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  void _showDialog({
    required String? room,
    required String time,
    required bool isFree,
  }) {
    showDialog(
      builder: (_) => AlertDialog(
        title: Text(
          isFree
              ? Strings.roomFreeDialogHeader
              : Strings.roomBookedDialogHeader,
        ),
        content: Text(
          isFree
              ? Strings.roomFreeDialogText(room!, time)
              : Strings.roomBookedDialogText,
        ),
        actions: isFree
            ? <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(Strings.cancel),
                ),
                TextButton(
                  onPressed: () {
                    onEmailButtonClicked(time: time, room: room!);
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
