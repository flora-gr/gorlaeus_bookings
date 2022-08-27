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

  final DateTime todayAtTwo = DateTime(2020, 1, 1, 14);

  BookingEntry getBookingEntry({TimeBlock? time, String? room}) => BookingEntry(
        time: time ??
            const TimeBlock(
              startTime: TimeOfDay(hour: 12, minute: 0),
              endTime: TimeOfDay(hour: 13, minute: 0),
            ),
        room: room ?? Rooms.room1,
        personCount: 10,
        bookedOnBehalfOf: '',
        activity: '',
        user: '',
      );

  List<BookingEntry> defaultBookingResponse = <BookingEntry>[getBookingEntry()];

  const TimeBlock overlappingTimeBlock = TimeBlock(
    startTime: TimeOfDay(hour: 12, minute: 0),
    endTime: TimeOfDay(hour: 18, minute: 0),
  );

  List<BookingEntry> fullyBookedResponse = Rooms.all
      .map((String room) =>
          getBookingEntry(time: overlappingTimeBlock, room: room))
      .toList();

  setUp(() {
    dateTimeProvider = MockDateTimeProvider();
    when(() => dateTimeProvider.getCurrentDateTime())
        .thenAnswer((_) => todayAtTwo);
    bookingProvider = MockBookingProvider();
    when(() => bookingProvider.getBookings(any()))
        .thenAnswer((_) async => defaultBookingResponse);
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

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'All rooms booked emits empty state',
    setUp: () => when(() => bookingProvider.getBookings(any()))
        .thenAnswer((_) async => fullyBookedResponse),
    build: () => sut,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(),
      const GetFreeRoomNowEmptyState(),
    ],
  );
}