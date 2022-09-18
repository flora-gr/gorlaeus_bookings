import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/booking_table/booking_data_source.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingTable extends StatelessWidget {
  const BookingTable(
    this._bookingsPerRoom,
    this._timeIfToday, {
    required this.onEmailButtonClicked,
    super.key,
  });

  final Map<String, Iterable<BookingEntry?>> _bookingsPerRoom;
  final TimeOfDay? _timeIfToday;
  final void Function({required String time, required String room})
      onEmailButtonClicked;

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
                  child: Text(
                    bookingTime.startTimeString(),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ),
            ),
          )
          .toList(),
      source: BookingDataSource(
        _bookingsPerRoom,
        _timeIfToday,
        onEmailButtonClicked: onEmailButtonClicked,
        context: context,
      ),
    );
  }
}
