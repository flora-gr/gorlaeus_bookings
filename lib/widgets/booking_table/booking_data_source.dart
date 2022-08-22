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
                        ? '$room Taken'
                        : '$room Free',
                    columnName: bookingTime.startTimeString(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  final BuildContext context;
  List<DataGridRow> _bookingData = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _bookingData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>(
      (DataGridCell cell) {
        return InkWell(
          onTap: () {
            showDialog(
              builder: (_) => AlertDialog(
                title: const Text('Want this room?'),
                content: Text(
                    'This room is ${cell.value.endsWith('Taken') ? 'taken.' : 'free.'}'),
              ),
              context: context,
            );
          },
          child: Container(
            color: cell.value.endsWith('Taken') ? Colors.red : Colors.green,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(cell.value),
          ),
        );
      },
    ).toList());
  }
}
