import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

class RoomsOverviewMapper {
  RoomsOverviewMapper();

  Future<Map<String, Iterable<BookingEntry?>>?> mapBookingEntries(
      List<BookingEntry>? bookings) async {
    return _mapForRooms<BookingEntry>(bookings, (BookingEntry? entry) => entry);
  }

  Future<Map<String, Iterable<TimeBlock?>>?> mapTimeBlocks(
      List<BookingEntry>? bookings) async {
    return _mapForRooms<TimeBlock>(
        bookings, (BookingEntry? entry) => entry?.time);
  }

  Future<Map<String, Iterable<T?>>?> _mapForRooms<T>(
      List<BookingEntry>? bookings,
      T? Function(BookingEntry? entry) mapper) async {
    if (bookings != null) {
      final Map<String, Iterable<T?>> iterableOfTPerRoom =
          <String, Iterable<T?>>{};
      for (String room in await _getRoomsToShow()) {
        final Iterable<BookingEntry?> bookingsForRoom =
            bookings.where((BookingEntry entry) => entry.room == room);
        iterableOfTPerRoom[room] = bookingsForRoom.map(mapper);
      }
      return iterableOfTPerRoom;
    }
    return null;
  }

  Future<Iterable<String>> _getRoomsToShow() async {
    final List<String> hiddenRooms =
        await getIt.get<SharedPreferencesRepository>().getHiddenRooms();
    return Rooms.all.where((String room) => !hiddenRooms.contains(room));
  }
}
