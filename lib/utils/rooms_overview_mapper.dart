import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

class RoomsOverviewMapper {
  RoomsOverviewMapper();

  Future<Map<String, Iterable<TimeBlock?>>?> mapToRoomsOverview(
      List<BookingEntry>? bookings) async {
    if (bookings != null) {
      final List<String> hiddenRooms =
          await getIt.get<SharedPreferencesRepository>().getHiddenRooms();
      final Iterable<String> roomsToShow =
          Rooms.all.where((String room) => !hiddenRooms.contains(room));

      final Map<String, Iterable<TimeBlock?>> roomsOverview =
          <String, Iterable<TimeBlock?>>{};
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
