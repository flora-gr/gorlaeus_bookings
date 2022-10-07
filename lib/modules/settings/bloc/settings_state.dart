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
    required this.selectedRooms,
    this.favouriteRoom,
  });

  final Iterable<String> selectedRooms;
  final String? favouriteRoom;

  SettingsReadyState copyWith({
    Iterable<String>? selectedRooms,
  }) {
    return SettingsReadyState(
      selectedRooms: selectedRooms ?? this.selectedRooms,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedRooms, favouriteRoom];
}
