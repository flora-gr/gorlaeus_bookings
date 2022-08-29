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

class MockBookingProvider extends Mock implements BookingRepository {}

class MockDateTimeProvider extends Mock implements DateTimeRepository {}

void main() {
  late BookingRepository bookingProvider;
  late DateTimeRepository dateTimeProvider;
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
    bookingProvider = MockBookingProvider();
    dateTimeProvider = MockDateTimeProvider();
    sut = BookingOverviewBloc(bookingProvider, dateTimeProvider);
  });

  blocTest<BookingOverviewBloc, BookingOverviewState>(
    'Initialization emits ready state',
    setUp: () => when(() => bookingProvider.getBookings(any()))
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
    setUp: () => when(() => bookingProvider.getBookings(any()))
        .thenThrow(Exception('Failed')),
    build: () => sut,
    act: (BookingOverviewBloc bloc) => bloc.add(BookingOverviewInitEvent(date)),
    expect: () => <BookingOverviewState>[
      const BookingOverviewBusyState(),
      const BookingOverviewErrorState(),
    ],
  );
}
