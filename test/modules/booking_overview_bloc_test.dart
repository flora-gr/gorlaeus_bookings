import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/booking_provider.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_event.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_state.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingProvider extends Mock implements BookingProvider {}

void main() {
  late BookingProvider bookingProvider;
  late BookingOverviewBloc sut;

  final DateTime date = DateTime.fromMillisecondsSinceEpoch(0);

  const List<BookingEntry> bookings = <BookingEntry>[
    BookingEntry(
      time: TimeBlock(
          startTime: TimeOfDay(hour: 12, minute: 0),
          endTime: TimeOfDay(hour: 13, minute: 0)),
      room: 'room',
      personCount: 10,
      bookedOnBehalfOf: '',
      activity: '',
      user: '',
    ),
  ];

  setUp(() {
    bookingProvider = MockBookingProvider();
    sut = BookingOverviewBloc(bookingProvider);
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
