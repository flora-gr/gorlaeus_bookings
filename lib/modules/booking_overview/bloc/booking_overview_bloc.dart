import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/data/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/data/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:gorlaeus_bookings/resources/connection_urls.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/utils/date_time_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingOverviewBloc
    extends Bloc<BookingOverviewEvent, BookingOverviewState> {
  BookingOverviewBloc(
    this._bookingRepository,
    this._dateTimeRepository,
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

  Stream<BookingOverviewState> _handleInitEvent(DateTime date) async* {
    yield const BookingOverviewBusyState();

    try {
      final List<BookingEntry>? bookings =
          await _bookingRepository.getBookings(date);
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
        date.isOnSameDateAs(_dateTimeRepository.getCurrentDateTime())
            ? Strings.today
            : Strings.onDay(date.formatted);

    await launchUrl(
      _getEmailUri(
        room: event.room,
        dateString: dateString,
        time: event.time,
      ),
    );
  }

  _getEmailUri({
    required String room,
    required String dateString,
    required String time,
  }) {
    return Uri(
      scheme: 'mailto',
      path: ConnectionUrls.serviceDeskEmail,
      query: <String, String>{
        'subject': Strings.bookRoomEmailSubject(room),
        'body': Strings.bookRoomEmailBody(room, dateString, time),
      }
          .entries
          .map(
            (MapEntry<String, dynamic> entry) =>
                '${Uri.encodeComponent(entry.key)}'
                '='
                '${Uri.encodeComponent(entry.value.toString())}',
          )
          .join('&'),
    );
  }
}
