import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/utils/time_block_extensions.dart';
import 'package:gorlaeus_bookings/widgets/booking_table/booking_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingTable extends StatelessWidget {
  const BookingTable(this._bookings);

  final List<BookingEntry> _bookings;

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      columns: BookingTimes.all
          .map(
            (TimeBlock bookingTime) => GridColumn(
              columnName: bookingTime.startDateString(),
              label: Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(bookingTime.startDateString()),
                  )),
            ),
          )
          .toList(),
      source: BookingDataSource(
        bookings: _bookings.toList(),
        context: context,
      ),
    );
  }
}
