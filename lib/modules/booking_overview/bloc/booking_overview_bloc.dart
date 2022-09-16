import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/extensions/date_time_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/connection_urls.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:gorlaeus_bookings/utils/url_launcher_wrapper.dart';

class BookingOverviewBloc
    extends Bloc<BookingOverviewEvent, BookingOverviewState> {
  BookingOverviewBloc() : super(const BookingOverviewBusyState()) {
    _dateTimeRepository = getIt.get<DateTimeRepository>();
    on<BookingOverviewInitEvent>(
        (BookingOverviewInitEvent event, Emitter<BookingOverviewState> emit) =>
            emit.forEach(_handleInitEvent(event.date),
                onData: (BookingOverviewState state) => state));
    on<BookingOverviewBookRoomEvent>((BookingOverviewBookRoomEvent event,
            Emitter<BookingOverviewState> emit) =>
        _handleBookRoomEvent(event));
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
            date: date,
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

  Future<void> _handleBookRoomEvent(BookingOverviewBookRoomEvent event) async {
    final DateTime date = (state as BookingOverviewReadyState).date;
    final String dateString =
        date.isOnSameDateAs(_dateTimeRepository.getCurrentDateTime())
            ? Strings.today
            : Strings.onDay(date.formatted);

    final String? emailName =
        await getIt.get<SharedPreferencesRepository>().getEmailName();

    await getIt.get<UrlLauncherWrapper>().launchEmail(
          ConnectionUrls.serviceDeskEmail,
          subject: Strings.bookRoomEmailSubject(event.room),
          body: Strings.bookRoomEmailBody(
              event.room, dateString, event.time, emailName),
        );
  }
}
