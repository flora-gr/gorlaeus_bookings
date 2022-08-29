import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/data/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/data/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/data/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

class MockDateTimeRepository extends Mock implements DateTimeRepository {}

void main() {
  late BookingRepository bookingRepository;
  late DateTimeRepository dateTimeRepository;
  late BookingOverviewBloc sut;

  final DateTime date = DateTime.fromMillisecondsSinceEpoch(0);

  const List<BookingEntry> bookings = <BookingEntry>[
    BookingEntry(
      time: TimeBlock(
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 13, minute: 0),
      ),
      room: 'room',
      personCount: 10,
      bookedOnBehalfOf: '',
      activity: '',
      user: '',
    ),
  ];

  setUp(() {
    bookingRepository = MockBookingRepository();
    dateTimeRepository = MockDateTimeRepository();
    sut = BookingOverviewBloc(bookingRepository, dateTimeRepository);
  });

  blocTest<BookingOverviewBloc, BookingOverviewState>(
    'Initialization emits ready state',
    setUp: () => when(() => bookingRepository.getBookings(any()))
        .thenAnswer((_) async => bookings),
    build: () => sut,
    act: (BookingOverviewBloc bloc) => bloc.add(BookingOverviewInitEvent(date)),
    expect: () => <BookingOverviewState>[
      const BookingOverviewBusyState(),
      BookingOverviewReadyState(
        date: date,
        bookings: bookings,
      ),
    ],
  );

  blocTest<BookingOverviewBloc, BookingOverviewState>(
    'Failure to fetch data emits error state',
    setUp: () => when(() => bookingRepository.getBookings(any()))
        .thenThrow(Exception('Failed')),
    build: () => sut,
    act: (BookingOverviewBloc bloc) => bloc.add(BookingOverviewInitEvent(date)),
    expect: () => <BookingOverviewState>[
      const BookingOverviewBusyState(),
      const BookingOverviewErrorState(),
    ],
  );
}
