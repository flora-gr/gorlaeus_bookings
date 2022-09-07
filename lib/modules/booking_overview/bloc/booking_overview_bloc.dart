import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/data/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/data/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:gorlaeus_bookings/resources/connection_urls.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/extensions/date_time_extensions.dart';
import 'package:gorlaeus_bookings/extensions/rooms_overview_mapper.dart';
import 'package:gorlaeus_bookings/utils/url_launcher_wrapper.dart';

class BookingOverviewBloc
    extends Bloc<BookingOverviewEvent, BookingOverviewState> {
  BookingOverviewBloc(
    this._bookingRepository,
    this._dateTimeRepository,
    this._mapper,
    this._urlLauncherWrapper,
  ) : super(const BookingOverviewBusyState()) {
    on<BookingOverviewInitEvent>(
        (BookingOverviewInitEvent event, Emitter<BookingOverviewState> emit) =>
            emit.forEach(_handleInitEvent(event.date),
                onData: (BookingOverviewState state) => state));
    on<BookingOverviewBookRoomEvent>((BookingOverviewBookRoomEvent event,
            Emitter<BookingOverviewState> emit) =>
        _handleBookRoomEvent(event));
  }

  final BookingRepository _bookingRepository;
  final DateTimeRepository _dateTimeRepository;
  final RoomsOverviewMapper _mapper;
  final UrlLauncherWrapper _urlLauncherWrapper;

  Stream<BookingOverviewState> _handleInitEvent(DateTime date) async* {
    yield const BookingOverviewBusyState();

    try {
      final List<BookingEntry>? bookings =
          await _bookingRepository.getBookings(date);
      if (bookings != null) {
        yield BookingOverviewReadyState(
          date: date,
          bookings: (await _mapper.mapToRoomsOverview(bookings))!,
        );
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

    await _urlLauncherWrapper.launchEmail(
      ConnectionUrls.serviceDeskEmail,
      subject: Strings.bookRoomEmailSubject(event.room),
      body: Strings.bookRoomEmailBody(event.room, dateString, event.time),
    );
  }
}
