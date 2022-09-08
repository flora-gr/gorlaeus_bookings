import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/booking_table/booking_data_source.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingTable extends StatelessWidget {
  const BookingTable(
    this._roomsOverview, {
    required this.onEmailButtonClicked,
    super.key,
  });

  final Map<String, Iterable<TimeBlock?>> _roomsOverview;
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
                  child: Text(bookingTime.startTimeString()),
                ),
              ),
            ),
          )
          .toList(),
      source: BookingDataSource(
        roomsOverview: _roomsOverview,
        onEmailButtonClicked: onEmailButtonClicked,
        context: context,
      ),
    );
  }
}
