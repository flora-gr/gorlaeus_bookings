import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

class RoomsOverviewMapper {
  RoomsOverviewMapper();

  Future<Map<String, Iterable<BookingEntry?>>?> mapBookingEntries(
      List<BookingEntry>? bookings) async {
    if (bookings != null) {
      final Map<String, Iterable<BookingEntry?>> bookingsPerRoom =
          <String, Iterable<BookingEntry?>>{};
      for (String room in await _getRoomsToShow()) {
        final Iterable<BookingEntry?> bookingsForRoom =
            bookings.where((BookingEntry entry) => entry.room == room);
        bookingsPerRoom[room] = bookingsForRoom;
      }
      return bookingsPerRoom;
    }
    return null;
  }

  Future<Map<String, Iterable<TimeBlock?>>?> mapTimeBlocks(
      List<BookingEntry>? bookings) async {
    if (bookings != null) {
      final Map<String, Iterable<TimeBlock?>> timeBlocksPerRoom =
          <String, Iterable<TimeBlock?>>{};
      for (String room in await _getRoomsToShow()) {
        final Iterable<BookingEntry?> bookingsForRoom =
            bookings.where((BookingEntry entry) => entry.room == room);
        timeBlocksPerRoom[room] =
            bookingsForRoom.map((BookingEntry? entry) => entry?.time);
      }
      return timeBlocksPerRoom;
    }
    return null;
  }

  Future<Iterable<String>> _getRoomsToShow() async {
    final List<String> hiddenRooms =
        await getIt.get<SharedPreferencesRepository>().getHiddenRooms();
    return Rooms.all.where((String room) => !hiddenRooms.contains(room));
  }
}
