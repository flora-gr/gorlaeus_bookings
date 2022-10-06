import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/extensions/date_time_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';

class BookingOverviewBloc
    extends Bloc<BookingOverviewEvent, BookingOverviewState> {
  BookingOverviewBloc() : super(const BookingOverviewBusyState()) {
    _dateTimeRepository = getIt.get<DateTimeRepository>();
    on<BookingOverviewInitEvent>(
        (BookingOverviewInitEvent event, Emitter<BookingOverviewState> emit) =>
            emit.forEach(_handleInitEvent(event.date),
                onData: (BookingOverviewState state) => state));
  }

  late DateTimeRepository _dateTimeRepository;

  Stream<BookingOverviewState> _handleInitEvent(DateTime date) async* {
    yield const BookingOverviewBusyState();

    try {
      final List<BookingEntry>? bookings =
          await getIt.get<BookingRepository>().getBookings(date);
      if (bookings != null) {
        final DateTime now = _dateTimeRepository.getCurrentDateTime();
        final TimeOfDay? timeIfToday = now.isOnSameDateAs(date)
            ? TimeOfDay(hour: now.hour, minute: now.minute)
            : null;
        final Map<String, Iterable<BookingEntry?>> bookingsPerRoom =
            (await getIt
                .get<RoomsOverviewMapper>()
                .mapBookingEntries(bookings))!;

        if (bookingsPerRoom.isEmpty) {
          yield const BookingOverviewEmptyState();
        } else {
          yield BookingOverviewReadyState(
            timeIfToday: timeIfToday,
            bookingsPerRoom: bookingsPerRoom,
          );
        }
      } else {
        yield const BookingOverviewErrorState();
      }
    } on Exception {
      yield const BookingOverviewErrorState();
    }
  }
}
