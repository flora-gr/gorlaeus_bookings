import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:gorlaeus_bookings/utils/url_launcher_wrapper.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

class MockDateTimeRepository extends Mock implements DateTimeRepository {}

class MockRoomsOverviewMapper extends Mock implements RoomsOverviewMapper {}

class MockSharedPreferencesRepository extends Mock
    implements SharedPreferencesRepository {}

class MockUrlLauncherWrapper extends Mock implements UrlLauncherWrapper {}

void main() {
  late BookingRepository bookingRepository;
  late DateTimeRepository dateTimeRepository;
  late RoomsOverviewMapper mapper;
  late SharedPreferencesRepository sharedPreferencesRepository;
  late UrlLauncherWrapper urlLauncherWrapper;
  late BookingOverviewBloc sut;

  final DateTime today = DateTime.fromMillisecondsSinceEpoch(0);
  final DateTime tomorrow = today.add(const Duration(days: 1));
  final TimeOfDay time = TimeOfDay(hour: today.hour, minute: today.minute);

  const List<BookingEntry> bookings = <BookingEntry>[
    BookingEntry(
      time: TimeBlock(
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 13, minute: 0),
      ),
      room: 'room',
      activity: '',
      user: '',
    ),
  ];

  Map<String, Iterable<BookingEntry?>> bookingsPerRoom =
      <String, Iterable<BookingEntry?>>{
    'room': <BookingEntry?>[bookings.first],
  };

  setUpAll(() {
    GetIt getIt = GetIt.instance;
    bookingRepository = MockBookingRepository();
    dateTimeRepository = MockDateTimeRepository();
    mapper = MockRoomsOverviewMapper();
    sharedPreferencesRepository = MockSharedPreferencesRepository();
    urlLauncherWrapper = MockUrlLauncherWrapper();
    getIt.registerSingleton<BookingRepository>(bookingRepository);
    getIt.registerSingleton<DateTimeRepository>(dateTimeRepository);
    getIt.registerSingleton<RoomsOverviewMapper>(mapper);
    getIt.registerSingleton<SharedPreferencesRepository>(
        sharedPreferencesRepository);
    getIt.registerSingleton<UrlLauncherWrapper>(urlLauncherWrapper);
  });

  setUp(() {
    when(() => dateTimeRepository.getCurrentDateTime())
        .thenAnswer((_) => today);
    when(() => urlLauncherWrapper.launchEmail(any(),
        subject: any(named: 'subject'),
        body: any(named: 'body'))).thenAnswer((_) async => <dynamic>{});
    sut = BookingOverviewBloc();
  });

  blocTest<BookingOverviewBloc, BookingOverviewState>(
    'Initialization for day that is today emits ready state with timeIfToday non-null',
    setUp: () {
      when(() => bookingRepository.getBookings(any()))
          .thenAnswer((_) async => bookings);
      when(() => mapper.mapBookingEntries(bookings))
          .thenAnswer((_) async => bookingsPerRoom);
    },
    build: () => sut,
    act: (BookingOverviewBloc bloc) =>
        bloc.add(BookingOverviewInitEvent(today)),
    expect: () => <BookingOverviewState>[
      const BookingOverviewBusyState(),
      BookingOverviewReadyState(
        date: today,
        timeIfToday: time,
        bookingsPerRoom: bookingsPerRoom,
      ),
    ],
  );

  blocTest<BookingOverviewBloc, BookingOverviewState>(
    'Initialization for day that is not today emits ready state with timeIfToday set to null',
    setUp: () {
      when(() => bookingRepository.getBookings(any()))
          .thenAnswer((_) async => bookings);
      when(() => mapper.mapBookingEntries(bookings))
          .thenAnswer((_) async => bookingsPerRoom);
    },
    build: () => sut,
    act: (BookingOverviewBloc bloc) =>
        bloc.add(BookingOverviewInitEvent(tomorrow)),
    expect: () => <BookingOverviewState>[
      const BookingOverviewBusyState(),
      BookingOverviewReadyState(
        date: tomorrow,
        timeIfToday: null,
        bookingsPerRoom: bookingsPerRoom,
      ),
    ],
  );

  blocTest<BookingOverviewBloc, BookingOverviewState>(
    'Failure to fetch data emits error state',
    setUp: () => when(() => bookingRepository.getBookings(any()))
        .thenThrow(Exception('Failed')),
    build: () => sut,
    act: (BookingOverviewBloc bloc) =>
        bloc.add(BookingOverviewInitEvent(today)),
    expect: () => <BookingOverviewState>[
      const BookingOverviewBusyState(),
      const BookingOverviewErrorState(),
    ],
  );

  blocTest<BookingOverviewBloc, BookingOverviewState>(
    'Empty bookingsPerRoom emits empty state',
    setUp: () {
      when(() => bookingRepository.getBookings(any()))
          .thenAnswer((_) async => bookings);
      when(() => mapper.mapBookingEntries(bookings))
          .thenAnswer((_) async => <String, Iterable<BookingEntry?>>{});
    },
    build: () => sut,
    act: (BookingOverviewBloc bloc) =>
        bloc.add(BookingOverviewInitEvent(today)),
    expect: () => <BookingOverviewState>[
      const BookingOverviewBusyState(),
      const BookingOverviewEmptyState(),
    ],
  );

  blocTest<BookingOverviewBloc, BookingOverviewState>(
    'Book room event launches email',
    setUp: () {
      when(() => sharedPreferencesRepository.getEmailName())
          .thenAnswer((_) async => 'name');
    },
    build: () => sut,
    seed: () => BookingOverviewReadyState(
      date: today,
      timeIfToday: null,
      bookingsPerRoom: bookingsPerRoom,
    ),
    act: (BookingOverviewBloc bloc) =>
        bloc.add(const BookingOverviewBookRoomEvent('8:00', 'room')),
    verify: (_) {
      verify(
        () => urlLauncherWrapper.launchEmail(
          any(),
          subject: any(named: 'subject'),
          body: any(named: 'body'),
        ),
      ).called(1);
    },
  );
}
