import 'dart:async';

import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  SharedPreferencesRepository();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const String hideRoomsKey = 'hideRooms';

  Future<bool> setHideRooms(List<String> rooms) async {
    return (await _prefs).setStringList(hideRoomsKey, rooms);
  }

  Future<List<String>> getHideRooms() async {
    return (await _prefs).getStringList(hideRoomsKey) ??
        <String>[Rooms.room13, Rooms.room21, Rooms.room22];
  }
}
