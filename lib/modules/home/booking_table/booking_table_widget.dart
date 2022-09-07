import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/modules/home/booking_table/booking_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingTable extends StatelessWidget {
  const BookingTable(
    this._bookings, {
    required this.onEmailButtonClicked,
    super.key,
  });

  final Map<String, Iterable<TimeBlock?>> _bookings;
  final void Function({
    required String time,
    required String room,
  }) onEmailButtonClicked;

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      columns: BookingTimes.all
          .map(
            (TimeBlock bookingTime) => GridColumn(
              columnName: bookingTime.startTimeString(),
              label: Container(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(bookingTime.startTimeString()),
                ),
              ),
            ),
          )
          .toList(),
      source: BookingDataSource(
        bookings: _bookings,
        onEmailButtonClicked: onEmailButtonClicked,
        context: context,
      ),
    );
  }
}
