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
    this.emailName,
  });

  final Iterable<String> rooms;
  final Iterable<String> selectedRooms;
  final String? emailName;

  SettingsReadyState copyWith({
    Iterable<String>? selectedRooms,
    String? emailName,
  }) {
    return SettingsReadyState(
      rooms: rooms,
      selectedRooms: selectedRooms ?? this.selectedRooms,
      emailName: emailName ?? this.emailName,
    );
  }

  @override
  List<Object?> get props => <Object?>[rooms, selectedRooms, emailName];
}
