import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/data/models/time_block.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';

void main() {
  test(
    'asString returns correct String',
    () {
      const TimeBlock timeBlock = TimeBlock(
        startTime: TimeOfDay(hour: 1, minute: 5),
        endTime: TimeOfDay(hour: 12, minute: 30),
      );

      expect(timeBlock.asString(), '01:05 - 12:30');
    },
  );

  test(
    'startTimeString returns correct String for start time',
    () {
      const TimeBlock timeBlock = TimeBlock(
        startTime: TimeOfDay(hour: 1, minute: 30),
        endTime: TimeOfDay(hour: 12, minute: 0),
      );

      expect(timeBlock.startTimeString(), '01:30');
    },
  );

  test(
    'overlapsWith returns true for overlapping time blocks',
    () {
      const TimeBlock timeBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 10, minute: 30),
        endTime: TimeOfDay(hour: 12, minute: 0),
      );

      const TimeBlock timeBlockWithSameStartTime = TimeBlock(
        startTime: TimeOfDay(hour: 10, minute: 30),
        endTime: TimeOfDay(hour: 15, minute: 0),
      );
      const TimeBlock timeBlockWithSameEndTime = TimeBlock(
        startTime: TimeOfDay(hour: 9, minute: 30),
        endTime: TimeOfDay(hour: 12, minute: 0),
      );
      const TimeBlock timeBlockWithStartTimeWithinBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 11, minute: 30),
        endTime: TimeOfDay(hour: 15, minute: 0),
      );
      const TimeBlock timeBlockWithEndTimeWithinBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 9, minute: 30),
        endTime: TimeOfDay(hour: 11, minute: 0),
      );
      const TimeBlock
          timeBlockWithStartingBeforeAndEndingAfterBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 9, minute: 30),
        endTime: TimeOfDay(hour: 11, minute: 0),
      );
      const TimeBlock
          timeBlockWithStartingBeforeAndEndingWithinBlockToCompareTo =
          TimeBlock(
        startTime: TimeOfDay(hour: 10, minute: 45),
        endTime: TimeOfDay(hour: 11, minute: 30),
      );

      expect(
          timeBlockWithSameStartTime.overlapsWith(timeBlockToCompareTo), true);
      expect(timeBlockWithSameEndTime.overlapsWith(timeBlockToCompareTo), true);
      expect(
          timeBlockWithStartTimeWithinBlockToCompareTo
              .overlapsWith(timeBlockToCompareTo),
          true);
      expect(
          timeBlockWithEndTimeWithinBlockToCompareTo
              .overlapsWith(timeBlockToCompareTo),
          true);
      expect(
          timeBlockWithStartingBeforeAndEndingAfterBlockToCompareTo
              .overlapsWith(timeBlockToCompareTo),
          true);
      expect(
          timeBlockWithStartingBeforeAndEndingWithinBlockToCompareTo
              .overlapsWith(timeBlockToCompareTo),
          true);
    },
  );

  test(
    'overlapsWith returns false for non-overlapping time blocks',
    () {
      const TimeBlock timeBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 10, minute: 30),
        endTime: TimeOfDay(hour: 12, minute: 0),
      );

      const TimeBlock timeBlockEndingBeforeBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 6, minute: 30),
        endTime: TimeOfDay(hour: 10, minute: 0),
      );
      const TimeBlock timeBlockStartingAfterBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 6, minute: 30),
        endTime: TimeOfDay(hour: 10, minute: 0),
      );
      const TimeBlock timeBlockEndingAtStartTimeOfBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 6, minute: 30),
        endTime: TimeOfDay(hour: 10, minute: 0),
      );
      const TimeBlock timeBlockStartingAtEndTimeOfBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 6, minute: 30),
        endTime: TimeOfDay(hour: 10, minute: 0),
      );

      expect(
          timeBlockEndingBeforeBlockToCompareTo
              .overlapsWith(timeBlockToCompareTo),
          false);
      expect(
          timeBlockStartingAfterBlockToCompareTo
              .overlapsWith(timeBlockToCompareTo),
          false);
      expect(
          timeBlockEndingAtStartTimeOfBlockToCompareTo
              .overlapsWith(timeBlockToCompareTo),
          false);
      expect(
          timeBlockStartingAtEndTimeOfBlockToCompareTo
              .overlapsWith(timeBlockToCompareTo),
          false);
    },
  );
}
