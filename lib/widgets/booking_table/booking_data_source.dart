import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
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
                        ? '$room Booked'
                        : '$room Free',
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
        final bool isFree = cell.value.endsWith('Free');
        final String? room =
            isFree ? cell.value!.replaceAll(' Free', '') : null;
        return InkWell(
          onTap: () {
            showDialog(
              builder: (_) => AlertDialog(
                title: Text(isFree
                    ? 'Want to book room $room at ${cell.columnName}?'
                    : 'Sorry!'),
                content: Text(
                    'This room is ${isFree ? 'available' : 'already booked'}.'),
                actions: isFree
                    ? <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            onEmailButtonClicked(
                              time: cell.columnName,
                              room: room!,
                            );
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes, send email'),
                        ),
                      ]
                    : null,
              ),
              context: context,
            );
          },
          child: Container(
            color: isFree ? Colors.green : Colors.red,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(cell.value),
          ),
        );
      },
    ).toList());
  }
}
