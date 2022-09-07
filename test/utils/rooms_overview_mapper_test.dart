import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/data/models/time_block.dart';
import 'package:gorlaeus_bookings/data/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferencesRepository extends Mock
    implements SharedPreferencesRepository {}

void main() {
  late SharedPreferencesRepository sharedPreferencesRepository;
  late RoomsOverviewMapper sut;

  setUp(() {
    sharedPreferencesRepository = MockSharedPreferencesRepository();
    when(() => sharedPreferencesRepository.getHiddenRooms())
        .thenAnswer((_) async => <String>[Rooms.room3]);
    sut = RoomsOverviewMapper(sharedPreferencesRepository);
  });

  const TimeBlock bookingTimeBlock = TimeBlock(
    startTime: TimeOfDay(hour: 12, minute: 0),
    endTime: TimeOfDay(hour: 13, minute: 0),
  );

  const List<BookingEntry> bookings = <BookingEntry>[
    BookingEntry(
      time: bookingTimeBlock,
      room: Rooms.room1,
      personCount: 10,
      bookedOnBehalfOf: '',
      activity: '',
      user: '',
    ),
  ];

  test(
    'mapToRoomsOverview returns map of all rooms with TimeBlocks if available',
    () async {
      final Map<String, Iterable<TimeBlock?>>? result =
          await sut.mapToRoomsOverview(bookings);

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
    },
  );
}
