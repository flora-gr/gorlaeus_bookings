import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/utils/time_block_extensions.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/utils/date_time_extensions.dart';

class BookingOverviewPage extends StatefulWidget {
  const BookingOverviewPage(
    this._bloc,
    this._date, {
    Key? key,
  }) : super(key: key);

  final BookingOverviewBloc _bloc;
  final DateTime _date;

  @override
  State<BookingOverviewPage> createState() => _BookingOverviewPageState();
}

class _BookingOverviewPageState extends State<BookingOverviewPage> {
  late BookingOverviewBloc _bloc;

  @override
  void initState() {
    _bloc = widget._bloc..add(BookingOverviewInitEvent(widget._date));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingOverviewBloc, BookingOverviewState>(
      bloc: _bloc,
      builder: (BuildContext context, BookingOverviewState state) => Scaffold(
        appBar: AppBar(
          title: const Text(Strings.bookingOverviewPageTitle),
        ),
        body: state is BookingOverviewReadyState
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          '${Strings.bookingsOn} ${state.date.formatted}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      if (state.bookings.isNotEmpty) ...<Widget>[
                        ...state.bookings.map(
                          (BookingEntry booking) =>
                              Text('${booking.toString()}\n'),
                        ),
                        _buildTable(state.bookings),
                      ] else
                        const Text(Strings.noBookings),
                    ],
                  ),
                ),
              )
            : Center(
                child: state is BookingOverviewBusyState
                    ? const CircularProgressIndicator()
                    : const Text(Strings.errorFetchingBookings),
              ),
      ),
    );
  }

  Widget _buildTable(Iterable<BookingEntry> bookings) {
    return SfDataGrid(
      columns: BookingTimes.all
          .map(
            (TimeBlock bookingTime) => GridColumn(
              columnName: bookingTime.startDateString(),
              label: Text(bookingTime.startDateString()),
            ),
          )
          .toList(),
      source: BookingDataSource(
        bookings: bookings.toList(),
        context: context,
      ),
    );
  }
}

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
                    columnName: bookingTime.startDateString(),
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
