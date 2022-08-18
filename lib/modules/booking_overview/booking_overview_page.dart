import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';

class BookingOverviewPage extends StatefulWidget {
  const BookingOverviewPage(
    this._bloc, {
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  final BookingOverviewBloc _bloc;

  @override
  State<BookingOverviewPage> createState() => _BookingOverviewPageState();
}

class _BookingOverviewPageState extends State<BookingOverviewPage> {
  late BookingOverviewBloc _bloc;

  @override
  void initState() {
    _bloc = widget._bloc..add(const BookingOverviewInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingOverviewBloc, BookingOverviewState>(
      bloc: _bloc,
      builder: (BuildContext context, BookingOverviewState state) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: state is BookingOverviewReadyState
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('\nBookings on 16-9-2022\n'),
                      ...state.bookings.map(
                        (BookingEntry booking) =>
                            Text('${booking.toString()}\n'),
                      )
                    ],
                  ),
                )
              : state is BookingOverviewBusyState
                  ? const CircularProgressIndicator()
                  : const Text('Failed to fetch bookings'),
        ),
      ),
    );
  }
}
