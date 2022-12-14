import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferencesRepository extends Mock
    implements SharedPreferencesRepository {}

void main() {
  late SharedPreferencesRepository sharedPreferencesRepository;
  late RoomsOverviewMapper sut;

  setUpAll(() {
    GetIt getIt = GetIt.instance;
    sharedPreferencesRepository = MockSharedPreferencesRepository();
    getIt.registerSingleton<SharedPreferencesRepository>(
        sharedPreferencesRepository);
  });

  setUp(() {
    when(() => sharedPreferencesRepository.getHiddenRooms())
        .thenAnswer((_) async => <String>[Rooms.room3]);
    when(() => sharedPreferencesRepository.getFavouriteRoom())
        .thenAnswer((_) async => Rooms.room2);
    sut = RoomsOverviewMapper();
  });

  const TimeBlock bookingTimeBlock = TimeBlock(
    startTime: TimeOfDay(hour: 12, minute: 0),
    endTime: TimeOfDay(hour: 13, minute: 0),
  );

  const List<BookingEntry> bookings = <BookingEntry>[
    BookingEntry(
      time: bookingTimeBlock,
      room: Rooms.room1,
      activity: '',
      user: '',
    ),
  ];

  test(
    'mapBookingEntries returns map of all rooms with BookingEntries if available',
    () async {
      final Map<String, Iterable<BookingEntry?>>? result =
          await sut.mapBookingEntries(bookings);

      expect(
        result!.length == Rooms.all.length - 1,
        true,
        reason: 'Should include all rooms except for one',
      );
      expect(
        result[Rooms.room1]?.length == 1 &&
            result[Rooms.room1]!.first == bookings.first,
        true,
        reason: 'Should include booking entry from bookings',
      );
      expect(
        result[Rooms.room2]?.isEmpty,
        true,
        reason: 'Should have empty list if no entry in bookings',
      );
      expect(
        result[Rooms.room3] == null,
        true,
        reason: 'Room should be hidden',
      );
      expect(
        result.keys.first == Rooms.room2,
        true,
        reason: 'Favourite room should be returned first',
      );
    },
  );

  test(
    'mapTimeBlocks returns map of all rooms with TimeBlocks if available',
    () async {
      final Map<String, Iterable<TimeBlock?>>? result =
          await sut.mapTimeBlocks(bookings);

      expect(
        result!.length == Rooms.all.length - 1,
        true,
        reason: 'Should include all rooms except for one',
      );
      expect(
        result[Rooms.room1]?.length == 1 &&
            result[Rooms.room1]!.first == bookingTimeBlock,
        true,
        reason: 'Should include entry time from bookings',
      );
      expect(
        result[Rooms.room2]?.isEmpty,
        true,
        reason: 'Should have empty list if no entry in bookings',
      );
      expect(
        result[Rooms.room3] == null,
        true,
        reason: 'Room should be hidden',
      );
      expect(
        result.keys.first == Rooms.room2,
        true,
        reason: 'Favourite room should be returned first',
      );
    },
  );
}
