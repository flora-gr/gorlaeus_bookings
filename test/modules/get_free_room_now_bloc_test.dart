import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/booking_provider.dart';
import 'package:gorlaeus_bookings/data/date_time_provider.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:mocktail/mocktail.dart';

class MockDateTimeProvider extends Mock implements DateTimeProvider {}

class MockBookingProvider extends Mock implements BookingProvider {}

void main() {
  late DateTimeProvider dateTimeProvider;
  late BookingProvider bookingProvider;
  late GetFreeRoomNowBloc sut;

  final DateTime today = DateTime.fromMillisecondsSinceEpoch(0);

  const List<BookingEntry> bookings = <BookingEntry>[
    BookingEntry(
      time: TimeBlock(
          startTime: TimeOfDay(hour: 12, minute: 0),
          endTime: TimeOfDay(hour: 13, minute: 0)),
      room: Rooms.room1,
      personCount: 10,
      bookedOnBehalfOf: '',
      activity: '',
      user: '',
    ),
  ];

  setUp(() {
    dateTimeProvider = MockDateTimeProvider();
    when(() => dateTimeProvider.getCurrentDateTime()).thenAnswer((_) => today);
    bookingProvider = MockBookingProvider();
    when(() => bookingProvider.getBookings(any()))
        .thenAnswer((_) async => bookings);
    sut = GetFreeRoomNowBloc(dateTimeProvider, bookingProvider);
  });

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'FetchGetFreeRoomNowSearchEventing fetches data and emits ready state with freeRooms and freeRoom',
    build: () => sut,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(),
      predicate((GetFreeRoomNowReadyState state) =>
          state.freeRooms != null && state.freeRoom != null),
    ],
    verify: (_) {
      verify(() => bookingProvider.getBookings(any())).called(1);
    },
  );

  const GetFreeRoomNowReadyState seedState = GetFreeRoomNowReadyState(
    freeRooms: <String>[Rooms.room1, Rooms.room2],
    freeRoom: Rooms.room1,
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'GetFreeRoomNowSearchEvent when freeRooms is available emits ready state with freeRooms and freeRoom without fetching new data',
    build: () => sut,
    seed: () => seedState,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      GetFreeRoomNowBusyState(freeRoom: seedState.freeRoom),
      predicate(
        (GetFreeRoomNowReadyState state) =>
            state.freeRooms == seedState.freeRooms &&
            seedState.freeRooms!.contains(state.freeRoom),
      ),
    ],
    verify: (_) {
      verifyNever(() => bookingProvider.getBookings(any()));
    },
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'Failure to fetch data emits error state',
    setUp: () => when(() => bookingProvider.getBookings(any()))
        .thenAnswer((_) async => null),
    build: () => sut,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(),
      const GetFreeRoomNowErrorState(),
    ],
  );
}
