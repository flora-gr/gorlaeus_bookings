import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/extensions/data_grid_cell_extensions.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  const DataGridCell cell = DataGridCell<String>(
    columnName: '09:00',
    value: Rooms.room1,
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
}
