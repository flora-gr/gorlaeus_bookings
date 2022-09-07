import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/data/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/data/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/data/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:mocktail/mocktail.dart';

class MockDateTimeRepository extends Mock implements DateTimeRepository {}

class MockBookingRepository extends Mock implements BookingRepository {}

class MockRoomsOverviewMapper extends Mock implements RoomsOverviewMapper {}

void main() {
  late DateTimeRepository dateTimeRepository;
  late BookingRepository bookingRepository;
  late RoomsOverviewMapper mapper;
  late GetFreeRoomNowBloc sut;

  final DateTime todayAtTwo = DateTime(2020, 1, 1, 14);

  const BookingEntry defaultBookingEntry = BookingEntry(
    time: TimeBlock(
      startTime: TimeOfDay(hour: 12, minute: 0),
      endTime: TimeOfDay(hour: 13, minute: 0),
    ),
    room: Rooms.room1,
    personCount: 10,
    bookedOnBehalfOf: '',
    activity: '',
    user: '',
  );

  List<BookingEntry> defaultBookingResponse = <BookingEntry>[
    defaultBookingEntry
  ];

  Map<String, Iterable<TimeBlock?>> mappedBooking =
      <String, Iterable<TimeBlock?>>{
    Rooms.room1: <TimeBlock?>[defaultBookingEntry.time],
  };

  const TimeBlock overlappingTimeBlock = TimeBlock(
    startTime: TimeOfDay(hour: 12, minute: 0),
    endTime: TimeOfDay(hour: 18, minute: 0),
  );

  Map<String, Iterable<TimeBlock?>> fullyBookedMappedBookings() {
    final Iterable<Iterable<TimeBlock?>> timeBlocks =
        Rooms.all.map((String room) => <TimeBlock?>[overlappingTimeBlock]);
    return Map<String, Iterable<TimeBlock?>>.fromIterables(
        Rooms.all, timeBlocks);
  }

  setUp(() {
    dateTimeRepository = MockDateTimeRepository();
    when(() => dateTimeRepository.getCurrentDateTime())
        .thenAnswer((_) => todayAtTwo);
    bookingRepository = MockBookingRepository();
    when(() => bookingRepository.getBookings(any()))
        .thenAnswer((_) async => defaultBookingResponse);
    mapper = MockRoomsOverviewMapper();
    when(() => mapper.mapToRoomsOverview(any()))
        .thenAnswer((_) async => mappedBooking);
    sut = GetFreeRoomNowBloc(
      dateTimeRepository,
      bookingRepository,
      mapper,
    );
  });

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'FetchGetFreeRoomNowSearchEventing fetches data and emits ready state with bookings and freeRoom',
    build: () => sut,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(),
      predicate((GetFreeRoomNowReadyState state) =>
          state.bookings != null && state.freeRoom != null),
    ],
    verify: (_) {
      verify(() => bookingRepository.getBookings(any())).called(1);
    },
  );

  GetFreeRoomNowReadyState seedState = GetFreeRoomNowReadyState(
    bookings: defaultBookingResponse,
    freeRoom: Rooms.room1,
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'GetFreeRoomNowSearchEvent when bookings is available emits ready state with bookings and freeRoom without fetching new data',
    build: () => sut,
    seed: () => seedState,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      GetFreeRoomNowBusyState(freeRoom: seedState.freeRoom),
      predicate(
        (GetFreeRoomNowReadyState state) =>
            state.bookings == seedState.bookings &&
            seedState.bookings!
                .any((BookingEntry entry) => entry.room == state.freeRoom),
      ),
    ],
    verify: (_) {
      verifyNever(() => bookingRepository.getBookings(any()));
    },
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'Failure to fetch data emits error state',
    setUp: () => when(() => mapper.mapToRoomsOverview(any()))
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
    setUp: () => when(() => mapper.mapToRoomsOverview(any()))
        .thenAnswer((_) async => fullyBookedMappedBookings()),
    build: () => sut,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(),
      const GetFreeRoomNowEmptyState(),
    ],
  );
}
