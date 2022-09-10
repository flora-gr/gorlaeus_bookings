import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';

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

  test(
    'isAfter returns true when time block starts after other time block',
    () {
      const TimeBlock timeBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 8, minute: 30),
        endTime: TimeOfDay(hour: 10, minute: 0),
      );

      const TimeBlock timeBlockStartingAfterBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 11, minute: 30),
        endTime: TimeOfDay(hour: 12, minute: 0),
      );
      const TimeBlock timeBlockStartingAtEndTimeOfBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 10, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
      );

      expect(
          timeBlockStartingAfterBlockToCompareTo.isAfter(timeBlockToCompareTo),
          true);
      expect(
          timeBlockStartingAtEndTimeOfBlockToCompareTo
              .isAfter(timeBlockToCompareTo),
          true);
    },
  );

  test(
    'isAfter returns false when time block does not start after other time block',
    () {
      const TimeBlock timeBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 8, minute: 30),
        endTime: TimeOfDay(hour: 10, minute: 0),
      );

      const TimeBlock timeBlockEndingBeforeBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 6, minute: 0),
        endTime: TimeOfDay(hour: 8, minute: 0),
      );
      const TimeBlock timeBlockEndingAtStartTimeOfBlockToCompareTo = TimeBlock(
        startTime: TimeOfDay(hour: 6, minute: 0),
        endTime: TimeOfDay(hour: 8, minute: 30),
      );
      const TimeBlock timeBlockEndingAfterStartTimeOfBlockToCompareTo =
          TimeBlock(
        startTime: TimeOfDay(hour: 6, minute: 0),
        endTime: TimeOfDay(hour: 8, minute: 30),
      );

      expect(
          timeBlockEndingBeforeBlockToCompareTo.isAfter(timeBlockToCompareTo),
          false);
      expect(
          timeBlockEndingAtStartTimeOfBlockToCompareTo
              .isAfter(timeBlockToCompareTo),
          false);
      expect(
          timeBlockEndingAfterStartTimeOfBlockToCompareTo
              .isAfter(timeBlockToCompareTo),
          false);
      expect(timeBlockToCompareTo.isAfter(timeBlockToCompareTo), false);
    },
  );

  test(
    'sort extension sorts Iterable of TimeBlocks correctly',
    () {
      const TimeBlock timeBlock1 = TimeBlock(
        startTime: TimeOfDay(hour: 4, minute: 0),
        endTime: TimeOfDay(hour: 5, minute: 0),
      );
      const TimeBlock timeBlock2 = TimeBlock(
        startTime: TimeOfDay(hour: 6, minute: 0),
        endTime: TimeOfDay(hour: 7, minute: 0),
      );
      const TimeBlock timeBlock3 = TimeBlock(
        startTime: TimeOfDay(hour: 7, minute: 0),
        endTime: TimeOfDay(hour: 8, minute: 0),
      );
      const TimeBlock timeBlock4 = TimeBlock(
        startTime: TimeOfDay(hour: 12, minute: 0),
        endTime: TimeOfDay(hour: 13, minute: 30),
      );
      const Iterable<TimeBlock> iterableToSort1 = <TimeBlock>[
        timeBlock2,
        timeBlock4,
        timeBlock3,
        timeBlock1,
      ];
      const Iterable<TimeBlock> iterableToSort2 = <TimeBlock>[
        timeBlock4,
        timeBlock3,
        timeBlock2,
        timeBlock1,
      ];
      const Iterable<TimeBlock> iterableToSort3 = <TimeBlock>[
        timeBlock1,
        timeBlock2,
        timeBlock3,
        timeBlock4,
      ];
      const Iterable<TimeBlock> iterableToSort4 = <TimeBlock>[
        timeBlock2,
        timeBlock2,
        timeBlock1,
        timeBlock1,
      ];
      const Iterable<TimeBlock?> iterableToSort5 = <TimeBlock?>[
        null,
        timeBlock2,
        timeBlock1,
        timeBlock1,
      ];

      const List<TimeBlock> sortedList123 = <TimeBlock>[
        timeBlock1,
        timeBlock2,
        timeBlock3,
        timeBlock4,
      ];

      expect(iterableToSort1.sort(), sortedList123);
      expect(iterableToSort2.sort(), sortedList123);
      expect(iterableToSort3.sort(), sortedList123);
      expect(
        iterableToSort4.sort(),
        <TimeBlock>[
          timeBlock1,
          timeBlock1,
          timeBlock2,
          timeBlock2,
        ],
      );
      expect(
        iterableToSort5.sort(),
        <TimeBlock?>[
          null,
          timeBlock1,
          timeBlock1,
          timeBlock2,
        ],
      );
    },
  );
}
