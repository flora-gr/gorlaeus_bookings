import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/booking_provider.dart';
import 'package:gorlaeus_bookings/data/date_time_provider.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:gorlaeus_bookings/utils/date_time_extensions.dart';
import 'package:gorlaeus_bookings/utils/time_block_extensions.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookingOverviewBloc
    extends Bloc<BookingOverviewEvent, BookingOverviewState> {
  BookingOverviewBloc(
    this._bookingProvider,
    this._dateTimeProvider,
  ) : super(const BookingOverviewBusyState()) {
    on<BookingOverviewInitEvent>(
      (BookingOverviewInitEvent event, Emitter<BookingOverviewState> emit) =>
          emit.forEach(_handleInitEvent(event.date),
              onData: (BookingOverviewState state) => state),
    );
    on<BookingOverviewBookRoomEvent>((BookingOverviewBookRoomEvent event,
            Emitter<BookingOverviewState> emit) =>
        _handleBookRoomEvent(event));
  }

  final BookingProvider _bookingProvider;
  final DateTimeProvider _dateTimeProvider;

  Stream<BookingOverviewState> _handleInitEvent(DateTime date) async* {
    yield const BookingOverviewBusyState();

    try {
      final List<BookingEntry>? bookings =
          await _bookingProvider.getBookings(date);
      if (bookings != null) {
        yield BookingOverviewReadyState(
          date: date,
          bookings: bookings,
        );
      } else {
        yield const BookingOverviewErrorState();
      }
    } on Exception {
      yield const BookingOverviewErrorState();
    }
  }

  _handleBookRoomEvent(BookingOverviewBookRoomEvent event) async {
    final DateTime date = (state as BookingOverviewReadyState).date;
    final String dateString =
        date.isOnSameDateAs(_dateTimeProvider.getCurrentDateTime())
            ? 'today'
            : 'on ${date.formatted}';
    final Mailto mailToLink = Mailto(
      to: <String>['servicedesk@science.leidenuniv.nl'],
      subject: 'Book room ${event.room}',
      body: 'Hello,<br><br>'
          'I would like to book room ${event.room} $dateString from ${event.time} for 2 hours.<br><br>'
          'Thanks in advance!'
    );
    await launchUrlString('$mailToLink');
  }
}
