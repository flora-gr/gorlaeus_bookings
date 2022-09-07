import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/data/models/time_block.dart';
import 'package:gorlaeus_bookings/data/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

class RoomsOverviewMapper {
  const RoomsOverviewMapper(this._sharedPreferencesRepository);

  final SharedPreferencesRepository _sharedPreferencesRepository;

  Future<Map<String, Iterable<TimeBlock?>>?> mapToRoomsOverview(
      List<BookingEntry>? bookings) async {
    if (bookings != null) {
      final Map<String, Iterable<TimeBlock?>> roomsOverview =
          <String, Iterable<TimeBlock?>>{};
      final List<String> hiddenRooms =
          await _sharedPreferencesRepository.getHiddenRooms();
      final Iterable<String> roomsToShow =
          Rooms.all.where((String room) => !hiddenRooms.contains(room));

      for (String room in roomsToShow) {
        final Iterable<BookingEntry?> bookingsForRoom =
            bookings.where((BookingEntry entry) => entry.room == room);
        roomsOverview[room] =
            bookingsForRoom.map((BookingEntry? entry) => entry?.time);
      }
      return roomsOverview;
    }
    return null;
  }
}
