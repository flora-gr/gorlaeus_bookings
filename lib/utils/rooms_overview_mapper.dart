import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/data/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

class RoomsOverviewMapper {
  const RoomsOverviewMapper();

  Map<String, Iterable<TimeBlock?>> mapToRoomsOverview(
      List<BookingEntry> bookings) {
    final Map<String, Iterable<TimeBlock?>> roomsOverview =
        <String, Iterable<TimeBlock?>>{};
    for (String room in Rooms.all) {
      final Iterable<BookingEntry?> bookingsForRoom =
          bookings.where((BookingEntry entry) => entry.room == room);
      roomsOverview[room] =
          bookingsForRoom.map((BookingEntry? entry) => entry?.time);
    }
    return roomsOverview;
  }
}
