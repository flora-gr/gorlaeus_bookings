import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/extensions/date_time_extensions.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/booking_table/booking_table_widget.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/theme/styles.dart';
import 'package:gorlaeus_bookings/widgets/loading_widgets.dart';

class BookingOverviewPage extends StatefulWidget {
  const BookingOverviewPage(
    this._bloc,
    this._date, {
    super.key,
  });

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
        body: Padding(
          padding: Styles.defaultPagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: Styles.verticalPadding8,
                child: Text(
                  '${Strings.bookingsOn} ${widget._date.formatted}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              if (state is BookingOverviewReadyState)
                ..._buildReadyBody(state)
              else
                Expanded(
                  child: Center(
                    child: state is BookingOverviewBusyState
                        ? const LoadingWidget()
                        : _buildEmptyOrErrorBody(state),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Iterable<Widget> _buildReadyBody(BookingOverviewReadyState state) {
    return <Widget>[
      if (state.bookingsPerRoom.keys.contains(Rooms.room13) ||
          state.bookingsPerRoom.keys.contains(Rooms.room21))
        const Padding(
          padding: Styles.verticalPadding8,
          child: Text(Strings.notLectureRooms),
        ),
      Expanded(
        child: BookingTable(
          state.bookingsPerRoom,
          state.timeIfToday,
          onEmailButtonTapped: ({
            required String time,
            required String room,
          }) =>
              _bloc.add(
            BookingOverviewBookRoomEvent(
              date: widget._date,
              time: time,
              room: room,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildEmptyOrErrorBody(BookingOverviewState state) {
    return Padding(
      padding: Styles.padding16,
      child: Text(
        state is BookingOverviewEmptyState
            ? Strings.noBookingsFound
            : Strings.fetchingBookingsFailed,
        textAlign: TextAlign.center,
      ),
    );
  }
}
