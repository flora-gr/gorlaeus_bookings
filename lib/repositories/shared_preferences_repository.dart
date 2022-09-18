import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  SharedPreferencesRepository();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const String hiddenRoomsKey = 'hiddenRooms';
  static const String emailNameKey = 'emailName';
  static const String themeModeKey = 'themeMode';

  Future<bool> setHiddenRooms(List<String> rooms) async {
    return (await _prefs).setStringList(hiddenRoomsKey, rooms);
  }

  Future<List<String>> getHiddenRooms() async {
    return (await _prefs).getStringList(hiddenRoomsKey) ??
        <String>[
          Rooms.room13,
          ...Rooms.cRooms,
          Rooms.room21,
          ...Rooms.building3,
        ];
  }

  Future<bool> setEmailName(String name) async {
    return (await _prefs).setString(emailNameKey, name);
  }

  Future<String?> getEmailName() async {
    return (await _prefs).getString(emailNameKey);
  }

  Future<bool> setThemeMode(ThemeMode themeMode) async {
    return (await _prefs).setString(themeModeKey, themeMode.name);
  }

  Future<ThemeMode> getThemeMode() async {
    return (await _prefs)
            .getString(themeModeKey)
            ?.toEnum<ThemeMode>(ThemeMode.values) ??
        ThemeMode.system;
  }
}
