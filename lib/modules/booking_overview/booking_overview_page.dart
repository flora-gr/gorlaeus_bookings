import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/utils/time_block_extensions.dart';
import 'package:gorlaeus_bookings/widgets/booking_table/booking_table_widget.dart';
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
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          '${Strings.bookingsOn} ${state.date.formatted}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      BookingTable(state.bookings),
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
}
