import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/booking_provider.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';

class BookingOverviewBloc
    extends Bloc<BookingOverviewEvent, BookingOverviewState> {
  BookingOverviewBloc(this._bookingProvider)
      : super(const BookingOverviewBusyState()) {
    on<BookingOverviewInitEvent>(
      (event, emit) => emit.forEach(_handleInitEvent(),
          onData: (BookingOverviewState state) => state),
    );
  }

  final BookingProvider _bookingProvider;

  Stream<BookingOverviewState> _handleInitEvent() async* {
    yield const BookingOverviewBusyState();

    try {
      final List<BookingEntry>? bookings =
          await _bookingProvider.getReservations();
      if (bookings != null) {
        yield BookingOverviewReadyState(bookings);
      } else {
        yield const BookingOverviewErrorState();
      }
    } on Exception {
      yield const BookingOverviewErrorState();
    }
  }
}
