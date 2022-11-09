import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

void main() {
  test(
    'toTimeBlock parses valid timeblock String to TimeBlock',
    () {
      const String timeBlockString = '10:00 12:00';

      expect(
        timeBlockString.toTimeBlock(),
        const TimeBlock(
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
        ),
      );
    },
  );

  test(
    'toTimeBlock returns null on invalid timeblock Strings',
    () {
      const String timeBlockStringShorterThan11Chars = '10:00 12:0';
      const String timeBlockStringLongerThan11Chars = '10:00 12:00a';
      const String timeBlockStringNoInt = 'aa:aa bb:bb';
      const String timeBlockStringTooManyColons = '1:0:0 1:2:0';
      const String timeBlockStringNoColons = '10.00 12.00';

      expect(timeBlockStringShorterThan11Chars.toTimeBlock(), null);
      expect(timeBlockStringLongerThan11Chars.toTimeBlock(), null);
      expect(timeBlockStringNoInt.toTimeBlock(), null);
      expect(timeBlockStringTooManyColons.toTimeBlock(), null);
      expect(timeBlockStringNoColons.toTimeBlock(), null);
    },
  );

  testWidgets(
    'toRoomName swaps the zero for a C for certain rooms only',
    (WidgetTester tester) async {
      tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            expect(Rooms.room17.toRoomName(context), 'C1');
            expect(Rooms.room18.toRoomName(context), 'C2');
            expect(Rooms.room19.toRoomName(context), 'C3');
            expect(Rooms.room20.toRoomName(context), 'C4/5');
            expect(Rooms.room15.toRoomName(context), Rooms.room15);

            return const Placeholder();
          },
        ),
      );
    },
  );

  test(
      'capitalize capitalizes the first character and leaves the rest of the string intact',
      () {
    expect('test'.capitalize(), 'Test');
    expect('tesT'.capitalize(), 'TesT');
    expect('Test'.capitalize(), 'Test');
    expect('TEST'.capitalize(), 'TEST');
    expect('t'.capitalize(), 'T');
    expect('T'.capitalize(), 'T');
  });
}
