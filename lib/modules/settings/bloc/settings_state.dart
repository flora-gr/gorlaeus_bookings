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

  final List<String> rooms;

  final List<String> selectedRooms;

  @override
  List<Object?> get props => <Object?>[rooms, selectedRooms];
}
