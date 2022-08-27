import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/utils/date_time_extensions.dart';

void main() {
  test(
    'formatted returns correct String',
    () {
      final DateTime date = DateTime(2020, 2, 1);

      expect(
        date.formatted,
        '01-02-2020',
        reason: 'Should have correct format',
      );
    },
  );

  test(
    'isOnSameDatesAs returns true for same dates',
    () {
      final DateTime dateTime = DateTime(2020, 2, 1);
      final DateTime sameDateTime = DateTime(2020, 2, 1);
      final DateTime sameDateDifferentTime = DateTime(2020, 2, 1, 1, 20);

      expect(
        dateTime.isOnSameDateAs(sameDateTime),
        true,
        reason: 'Is same date',
      );
      expect(
        dateTime.isOnSameDateAs(sameDateDifferentTime),
        true,
        reason: 'Is same date',
      );
    },
  );

  test(
    'isOnSameDatesAs returns true for different dates',
    () {
      final DateTime dateTime = DateTime(2020, 2, 1);
      final DateTime differentDateSameTime = DateTime(2020, 3, 1);
      final DateTime differentDateDifferentTime = DateTime(2020, 3, 1, 1, 20);

      expect(
        dateTime.isOnSameDateAs(differentDateSameTime),
        false,
        reason: 'Is different date',
      );
      expect(
        dateTime.isOnSameDateAs(differentDateDifferentTime),
        false,
        reason: 'Is different date',
      );
    },
  );

  test(
    'isWeekendDay returns true for weekend days',
    () {
      final DateTime saturday = DateTime(2022, 8, 27);
      final DateTime sunday = DateTime(2022, 8, 28);

      expect(
        saturday.isWeekendDay(),
        true,
        reason: 'Saturday is in the weekend',
      );
      expect(
        sunday.isWeekendDay(),
        true,
        reason: 'Sunday is in the weekend',
      );
    },
  );

  test(
    'isWeekendDay returns false for week days',
    () {
      final DateTime monday = DateTime(2022, 8, 29);
      final DateTime tuesday = DateTime(2022, 8, 30);
      final DateTime wednesday = DateTime(2022, 8, 31);
      final DateTime thursday = DateTime(2022, 9, 1);
      final DateTime friday = DateTime(2022, 9, 2);

      expect(monday.isWeekendDay(), false);
      expect(tuesday.isWeekendDay(), false);
      expect(wednesday.isWeekendDay(), false);
      expect(thursday.isWeekendDay(), false);
      expect(friday.isWeekendDay(), false);
    },
  );
}
