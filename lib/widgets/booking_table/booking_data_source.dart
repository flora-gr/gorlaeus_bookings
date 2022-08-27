import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:gorlaeus_bookings/utils/string_extensions.dart';
import 'package:gorlaeus_bookings/utils/time_block_extensions.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingDataSource extends DataGridSource {
  BookingDataSource({
    required List<BookingEntry> bookings,
    required this.onEmailButtonClicked,
    required this.context,
  }) {
    _bookingData = Rooms.all
        .map(
          (String room) => DataGridRow(
            cells: BookingTimes.all
                .map(
                  (TimeBlock bookingTime) => DataGridCell(
                    value: bookings.any((BookingEntry booking) =>
                            booking.room == room &&
                            booking.time!.overlapsWith(bookingTime))
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
            onTap: () {
              showDialog(
                builder: (_) => AlertDialog(
                  title: Text(
                    isFree
                        ? Strings.roomFreeDialogHeader
                        : Strings.roomBookedDialogHeader,
                  ),
                  content: Text(
                    isFree
                        ? Strings.roomFreeDialogText(room!, cell.columnName)
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
                              onEmailButtonClicked(
                                time: cell.columnName,
                                room: room!,
                              );
                              Navigator.of(context).pop();
                            },
                            child: const Text(Strings.yesBookRoom),
                          ),
                        ]
                      : null,
                ),
                context: context,
              );
            },
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
}
