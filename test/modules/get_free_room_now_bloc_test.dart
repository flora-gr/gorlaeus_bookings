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
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

class MockDateTimeRepository extends Mock implements DateTimeRepository {}

class MockRoomsOverviewMapper extends Mock implements RoomsOverviewMapper {}

class MockSharedPreferencesRepository extends Mock
    implements SharedPreferencesRepository {}

void main() {
  late DateTimeRepository dateTimeRepository;
  late BookingRepository bookingRepository;
  late RoomsOverviewMapper mapper;
  late SharedPreferencesRepository sharedPreferencesRepository;
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

  Map<String, Iterable<TimeBlock?>> timeBlocksWithOnlyRoom1StartingAfterNine =
      <String, Iterable<TimeBlock?>>{
    Rooms.room1: <TimeBlock?>[],
    Rooms.room2: <TimeBlock?>[
      const TimeBlock(
        startTime: TimeOfDay(hour: 9, minute: 0),
        endTime: TimeOfDay(hour: 11, minute: 0),
      ),
    ],
  };

  setUpAll(() {
    GetIt getIt = GetIt.instance;
    bookingRepository = MockBookingRepository();
    dateTimeRepository = MockDateTimeRepository();
    mapper = MockRoomsOverviewMapper();
    sharedPreferencesRepository = MockSharedPreferencesRepository();
    getIt.registerSingleton<BookingRepository>(bookingRepository);
    getIt.registerSingleton<DateTimeRepository>(dateTimeRepository);
    getIt.registerSingleton<RoomsOverviewMapper>(mapper);
    getIt.registerSingleton<SharedPreferencesRepository>(
        sharedPreferencesRepository);
  });

  setUp(() {
    when(() => bookingRepository.getBookings(any()))
        .thenAnswer((_) async => defaultBookingResponse);
    when(() => dateTimeRepository.getCurrentDateTime())
        .thenAnswer((_) => todayAtTwo);
    when(() => mapper.mapTimeBlocks(any()))
        .thenAnswer((_) async => timeBlocksPerRoom);
    when(() => sharedPreferencesRepository.getFavouriteRoom())
        .thenAnswer((_) async => null);
    sut = GetFreeRoomNowBloc();
  });

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'GetFreeRoomNowSearchEvent fetches data and emits ready state with timeBlocksPerRoom and freeRoom',
    build: () => sut,
    seed: () => const GetFreeRoomNowReadyState(),
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(favouriteRoomSearchSelected: true),
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
        favouriteRoomSearchSelected: true,
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
    'GetFreeRoomNowSearchEvent before 8:00 searches for room that is free until at least 10',
    setUp: () {
      when(() => dateTimeRepository.getCurrentDateTime())
          .thenAnswer((_) => DateTime(2022, 2, 2, 7, 30));
      when(() => mapper.mapTimeBlocks(any()))
          .thenAnswer((_) async => timeBlocksWithOnlyRoom1StartingAfterNine);
    },
    build: () => sut,
    seed: () => const GetFreeRoomNowReadyState(),
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(favouriteRoomSearchSelected: true),
      predicate(
        (GetFreeRoomNowReadyState state) => state.freeRoom == Rooms.room1,
      ),
    ],
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'Failure to fetch data emits error state',
    setUp: () =>
        when(() => mapper.mapTimeBlocks(any())).thenAnswer((_) async => null),
    build: () => sut,
    seed: () => const GetFreeRoomNowReadyState(favouriteRoom: Rooms.room1),
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(
        favouriteRoom: Rooms.room1,
        favouriteRoomSearchSelected: true,
      ),
      const GetFreeRoomNowErrorState(
        favouriteRoom: Rooms.room1,
        favouriteRoomSearchSelected: true,
      ),
    ],
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'All rooms booked emits empty state',
    setUp: () => when(() => mapper.mapTimeBlocks(any()))
        .thenAnswer((_) async => fullyBookedTimeBlocksPerRoom()),
    build: () => sut,
    seed: () =>
        const GetFreeRoomNowReadyState(favouriteRoomSearchSelected: false),
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSearchEvent()),
    expect: () => <dynamic>[
      const GetFreeRoomNowBusyState(favouriteRoomSearchSelected: false),
      GetFreeRoomNowEmptyState(
        timeBlocksPerRoom: fullyBookedTimeBlocksPerRoom(),
        favouriteRoomSearchSelected: false,
      ),
    ],
  );

  // TODO
  // blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
  //   'Searching for favourite room emits state',
  //   build: () => sut,
  //   act: (GetFreeRoomNowBloc bloc) =>
  //       bloc.add(const GetFreeRoomNowSearchEvent()),
  // );
  //
  // blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
  //   'Searching for favourite room emits state',
  //   build: () => sut,
  //   act: (GetFreeRoomNowBloc bloc) =>
  //       bloc.add(const GetFreeRoomNowSearchEvent()),
  // );
  //
  // blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
  //   'Changing radio button emits state',
  //   build: () => sut,
  //   act: (GetFreeRoomNowBloc bloc) => bloc.add(
  //       const GetFreeRoomNowRadioButtonChangedEvent(
  //           favouriteRoomSearchSelected: false)),
  // );
  //
  // blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
  //   'Changing radio button emits state',
  //   build: () => sut,
  //   act: (GetFreeRoomNowBloc bloc) => bloc.add(
  //       const GetFreeRoomNowRadioButtonChangedEvent(
  //           favouriteRoomSearchSelected: false)),
  // );

  GetFreeRoomNowReadyState seedStateWithSingleFreeRoom =
      GetFreeRoomNowReadyState(
    favouriteRoom: Rooms.room1,
    timeBlocksPerRoom: timeBlocksPerRoom,
    freeRoom: Rooms.room1,
    isOnlyRoom: true,
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'SharedPreferencesChangedEvent resets timeBlocksPerRoom in ready state to null and isOnlyRoom to false and updates favourite room',
    setUp: () => when(() => sharedPreferencesRepository.getFavouriteRoom())
        .thenAnswer((_) async => Rooms.room10),
    build: () => sut,
    seed: () => seedStateWithSingleFreeRoom,
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSharedPreferencesChangedEvent()),
    expect: () => <dynamic>[
      predicate(
        (GetFreeRoomNowReadyState state) =>
            state.timeBlocksPerRoom == null &&
            state.favouriteRoom == Rooms.room10 &&
            state.favouriteRoomSearchSelected ==
                seedStateWithSingleFreeRoom.favouriteRoomSearchSelected &&
            state.freeRoom == seedStateWithSingleFreeRoom.freeRoom &&
            state.nextBooking == seedStateWithSingleFreeRoom.nextBooking &&
            state.isOnlyRoom == false,
      ),
    ],
  );

  blocTest<GetFreeRoomNowBloc, GetFreeRoomNowState>(
    'SharedPreferencesChangedEvent when in empty state emits empty ready state but updates favourite room',
    setUp: () => when(() => sharedPreferencesRepository.getFavouriteRoom())
        .thenAnswer((_) async => Rooms.room10),
    build: () => sut,
    seed: () => GetFreeRoomNowEmptyState(
      timeBlocksPerRoom: timeBlocksPerRoom,
      favouriteRoom: Rooms.room1,
      favouriteRoomSearchSelected: true,
    ),
    act: (GetFreeRoomNowBloc bloc) =>
        bloc.add(const GetFreeRoomNowSharedPreferencesChangedEvent()),
    expect: () => <GetFreeRoomNowState>[
      const GetFreeRoomNowReadyState(
        favouriteRoom: Rooms.room10,
      )
    ],
  );
}
