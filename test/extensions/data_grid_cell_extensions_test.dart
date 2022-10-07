import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/extensions/data_grid_cell_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  const DataGridCell cell = DataGridCell<String>(
    columnName: '09:00',
    value: Rooms.room1,
  );

  const BookingEntry nonOverlappingBookingBeforeCellBookingTime = BookingEntry(
    time: TimeBlock(
      startTime: TimeOfDay(
        hour: 8,
        minute: 0,
      ),
      endTime: TimeOfDay(
        hour: 8,
        minute: 30,
      ),
    ),
    room: Rooms.room1,
    activity: '',
    user: '',
  );

  const BookingEntry nonOverlappingBookingAfterCellBookingTime = BookingEntry(
    time: TimeBlock(
      startTime: TimeOfDay(
        hour: 12,
        minute: 0,
      ),
      endTime: TimeOfDay(
        hour: 12,
        minute: 30,
      ),
    ),
    room: Rooms.room1,
    activity: '',
    user: '',
  );

  const BookingEntry overlappingBookingWithCellBookingTime = BookingEntry(
    time: TimeBlock(
      startTime: TimeOfDay(
        hour: 8,
        minute: 0,
      ),
      endTime: TimeOfDay(
        hour: 9,
        minute: 30,
      ),
    ),
    room: Rooms.room1,
    activity: '',
    user: '',
  );

  const BookingEntry overlappingBookingWithCellBookingTimeForOtherRoom =
      BookingEntry(
    time: TimeBlock(
      startTime: TimeOfDay(
        hour: 8,
        minute: 0,
      ),
      endTime: TimeOfDay(
        hour: 9,
        minute: 30,
      ),
    ),
    room: Rooms.room2,
    activity: '',
    user: '',
  );

  test(
    'room returns cell value as String',
    () {
      expect(
        cell.room(),
        Rooms.room1,
        reason: 'Should return cell value',
      );
    },
  );

  test(
    'bookingTime returns booking time belonging to cell column',
    () {
      expect(
        cell.bookingTime(),
        BookingTimes.time1,
        reason: 'Should return correct booking time for cell',
      );
    },
  );

  test(
    'isPast returns false if timeIfToday is null',
    () {
      expect(
        cell.isPast(null),
        false,
        reason: 'Should be false for timeIfToday is null',
      );
    },
  );

  test(
    'isPast returns false if not in past',
    () {
      expect(
        cell.isPast(const TimeOfDay(hour: 8, minute: 30)),
        false,
        reason: 'Should be false when time of today is before booking time',
      );
    },
  );

  test(
    'isPast returns true if in past',
    () {
      expect(
        cell.isPast(const TimeOfDay(hour: 10, minute: 30)),
        true,
        reason: 'Should be true when time of today is after booking time',
      );
    },
  );

  test(
    'bookings returns TimeBlocks that overlap with the booking time of the cell belonging to the cell room',
    () {
      final Map<String, Iterable<BookingEntry?>> bookingsPerRoom =
          <String, Iterable<BookingEntry?>>{
        Rooms.room1: <BookingEntry?>[
          nonOverlappingBookingBeforeCellBookingTime,
          nonOverlappingBookingAfterCellBookingTime,
          overlappingBookingWithCellBookingTime,
        ],
        Rooms.room2: <BookingEntry?>[
          overlappingBookingWithCellBookingTimeForOtherRoom,
        ],
      };

      expect(
        cell.bookings(bookingsPerRoom),
        <BookingEntry?>[overlappingBookingWithCellBookingTime],
        reason: 'Should return overlapping booking for this cell',
      );
    },
  );

  test(
    'freeTime returns correct String',
    () {
      final Map<String, Iterable<BookingEntry?>>
          bookingsPerRoomWithFreeSlotBetweenBookings =
          <String, Iterable<BookingEntry?>>{
        Rooms.room1: <BookingEntry?>[
          nonOverlappingBookingBeforeCellBookingTime,
          nonOverlappingBookingAfterCellBookingTime,
        ],
        Rooms.room2: <BookingEntry?>[
          overlappingBookingWithCellBookingTimeForOtherRoom,
        ],
      };

      final Map<String, Iterable<BookingEntry?>>
          bookingsPerRoomFreeForRestOfDay = <String, Iterable<BookingEntry?>>{
        Rooms.room1: <BookingEntry?>[
          nonOverlappingBookingBeforeCellBookingTime,
        ],
        Rooms.room2: <BookingEntry?>[
          overlappingBookingWithCellBookingTimeForOtherRoom,
        ],
      };

      final Map<String, Iterable<BookingEntry?>>
          bookingsPerRoomFreeUntilNextBooking =
          <String, Iterable<BookingEntry?>>{
        Rooms.room1: <BookingEntry?>[
          nonOverlappingBookingAfterCellBookingTime,
        ],
        Rooms.room2: <BookingEntry?>[
          overlappingBookingWithCellBookingTimeForOtherRoom,
        ],
      };

      final Map<String, Iterable<BookingEntry?>> bookingsPerRoomFreeAllDay =
          <String, Iterable<BookingEntry?>>{
        Rooms.room1: <BookingEntry?>[],
        Rooms.room2: <BookingEntry?>[
          overlappingBookingWithCellBookingTimeForOtherRoom,
        ],
      };

      expect(
        cell.freeTime(bookingsPerRoomWithFreeSlotBetweenBookings),
        'from 08:30-12:00',
        reason: 'Should return String indicating free time slot',
      );

      expect(
        cell.freeTime(bookingsPerRoomFreeForRestOfDay),
        'from 08:30',
        reason:
            'Should return String indicating free since previous booking end',
      );
      expect(
        cell.freeTime(bookingsPerRoomFreeUntilNextBooking),
        'until 12:00',
        reason: 'Should return String indicating free until next booking start',
      );
      expect(
        cell.freeTime(bookingsPerRoomFreeAllDay),
        'all day',
        reason: 'Should return String indicating free all day',
      );
    },
  );
}
