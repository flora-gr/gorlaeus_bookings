import 'package:gorlaeus_bookings/extensions/time_of_day_extensions.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';

extension TimeBlockExtensions on TimeBlock {
  String asString() {
    return '${startTimeString()}'
        ' - '
        '${_makePaddedString(endTime.hour)}:${_makePaddedString(endTime.minute)}';
  }

  String startTimeString() {
    return '${_makePaddedString(startTime.hour)}:${_makePaddedString(startTime.minute)}';
  }

  String _makePaddedString(int i) {
    return i.toString().padLeft(2, '0');
  }

  bool overlapsWith(TimeBlock bookingTime) {
    final int startTimeMinutes = startTime.asMinutes();
    final int endTimeMinutes = endTime.asMinutes();
    final int bookingStartTimeMinutes = bookingTime.startTime.asMinutes();
    final int bookingEndTimeMinutes = bookingTime.endTime.asMinutes();
    return startTimeMinutes >= bookingStartTimeMinutes &&
            startTimeMinutes < bookingEndTimeMinutes ||
        endTimeMinutes > bookingStartTimeMinutes &&
            endTimeMinutes <= bookingEndTimeMinutes ||
        startTimeMinutes <= bookingStartTimeMinutes &&
            endTimeMinutes >= bookingEndTimeMinutes;
  }

  bool isAfter(TimeBlock bookingTime) {
    return startTime.asMinutes() >= bookingTime.endTime.asMinutes();
  }
}

extension TimeBlockIterableExtension on Iterable<TimeBlock?> {
  List<TimeBlock?> sort() {
    return toList()
      ..sort(
        (TimeBlock? a, TimeBlock? b) {
          if (a == null || b == null) {
            return 0;
          } else {
            if (a.isAfter(b)) {
              return 1;
            } else if (b.isAfter(a)) {
              return -1;
            }
            return 0;
          }
        },
      );
  }
}
