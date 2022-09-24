import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

class MockDateTimeRepository extends Mock implements DateTimeRepository {}

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
    activity: '',
    user: '',
  );

  List<BookingEntry> defaultBookingResponse = <BookingEntry>[
    defaultBookingEntry
  ];

  Map<String, Iterable<TimeBlock?>> timeBlocksPerRoom =
      <String, Iterable<TimeBlock?>>{
    Rooms.room1: <TimeBlock?>[defaultBookingEntry.time],
  };

  const TimeBlock overlappingTimeBlock = TimeBlock(
    startTime: TimeOfDay(hour: 12, minute: 0),
    endTime: TimeOfDay(hour: 18, minute: 0),
  );

  Map<String, Iterable<TimeBlock?>> fullyBookedTimeBlocksPerRoom() {
    final Iterable<Iterable<TimeBlock?>> timeBlocks =
        Rooms.all.map((String room) => <TimeBlock?>[overlappingTimeBlock]);
    return Map<String, Iterable<TimeBlock?>>.fromIterables(
        Rooms.all, timeBlocks);
  }

  setUpAll(() {
    GetIt getIt = GetIt.instance;
    bookingRepository = MockBookingRepository();
    dateTimeRepository = MockDateTimeRepository();
    mapper = MockRoomsOverviewMapper();
    getIt.registerSingleton<BookingRepository>(bookingRepository);
    getIt.registerSingleton<DateTimeRepository>(dateTimeRepository);
    getIt.registerSingleton<RoomsOverviewMapper>(mapper);
  });

  setUp(() {
    when(() => bookingRepository.getBookings(any()))
        .thenAnswer((_) async => defaultBookingResponse);
    when(() => dateTimeRepository.getCurrentDateTime())
        .thenAnswer((_) => todayAtTwo);
    when(() => mapper.mapTimeBlocks(any()))
        .thenAnswer((_) async => timeBlocksPerRoom);
    sut = GetFreeRoomNowBloc();
  });

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'GetFreeRoomNowSearchEvent fetches data and emits ready state with timeBlocksPerRoom and freeRoom',
    build: () => sut,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(),
      predicate((GetFreeRoomNowReadyState state) =>
          state.timeBlocksPerRoom != null && state.freeRoom != null),
    ],
    verify: (_) {
      verify(() => bookingRepository.getBookings(any())).called(1);
    },
  );

  GetFreeRoomNowReadyState seedState = GetFreeRoomNowReadyState(
    timeBlocksPerRoom: timeBlocksPerRoom,
    freeRoom: Rooms.room1,
    nextBooking: defaultBookingEntry.time,
    isOnlyRoom: false,
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'GetFreeRoomNowSearchEvent when timeBlocksPerRoom is available emits ready state with timeBlocksPerRoom and freeRoom without fetching new data',
    build: () => sut,
    seed: () => seedState,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      GetFreeRoomNowBusyState(
        freeRoom: seedState.freeRoom,
        nextBooking: seedState.nextBooking,
        isOnlyRoom: seedState.isOnlyRoom,
      ),
      predicate(
        (GetFreeRoomNowReadyState state) =>
            state.timeBlocksPerRoom == seedState.timeBlocksPerRoom &&
            timeBlocksPerRoom.keys.contains(state.freeRoom),
      ),
    ],
    verify: (_) {
      verifyNever(() => bookingRepository.getBookings(any()));
    },
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'Failure to fetch data emits error state',
    setUp: () =>
        when(() => mapper.mapTimeBlocks(any())).thenAnswer((_) async => null),
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
    setUp: () => when(() => mapper.mapTimeBlocks(any()))
        .thenAnswer((_) async => fullyBookedTimeBlocksPerRoom()),
    build: () => sut,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(),
      const GetFreeRoomNowEmptyState(),
    ],
  );

  GetFreeRoomNowReadyState seedStateWithSingleFreeRoom =
      GetFreeRoomNowReadyState(
    timeBlocksPerRoom: timeBlocksPerRoom,
    freeRoom: Rooms.room1,
    isOnlyRoom: true,
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'SharedPreferencesChangedEvent resets timeBlocksPerRoom in ready state to null and isOnlyRoom to false',
    build: () => sut,
    seed: () => seedStateWithSingleFreeRoom,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSharedPreferencesChangedEvent()),
    expect: () => <dynamic>[
      predicate(
        (GetFreeRoomNowReadyState state) =>
            state.timeBlocksPerRoom == null &&
            state.freeRoom == seedStateWithSingleFreeRoom.freeRoom &&
            state.nextBooking == seedStateWithSingleFreeRoom.nextBooking &&
            state.isOnlyRoom == false,
      ),
    ],
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'SharedPreferencesChangedEvent when in empty state emits empty ready state',
    build: () => sut,
    seed: () => const GetFreeRoomNowEmptyState(),
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSharedPreferencesChangedEvent()),
    expect: () => <GetFreeRoomNowState>[const GetFreeRoomNowReadyState()],
  );
}
