import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsBusyState extends SettingsState {
  const SettingsBusyState();

  @override
  List<Object?> get props => <Object?>[];
}

class SettingsReadyState extends SettingsState {
  const SettingsReadyState({
    required this.rooms,
    required this.selectedRooms,
  });

  final Iterable<String> rooms;
  final Iterable<String> selectedRooms;

  SettingsReadyState copyWith(Iterable<String> selectedRooms) {
    return SettingsReadyState(
      rooms: rooms,
      selectedRooms: selectedRooms,
    );
  }

  @override
  List<Object?> get props => <Object?>[rooms, selectedRooms];
}
