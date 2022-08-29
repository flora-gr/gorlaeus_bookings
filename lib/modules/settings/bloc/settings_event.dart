import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInitEvent extends SettingsEvent {
  const SettingsInitEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class SettingsSelectedRoomsChangedEvent extends SettingsEvent {
  const SettingsSelectedRoomsChangedEvent(this.selectedRooms);

  final List<String> selectedRooms;

  @override
  List<Object?> get props => <Object?>[selectedRooms];
}

class SettingsSaveEvent extends SettingsEvent {
  const SettingsSaveEvent();

  @override
  List<Object?> get props => <Object?>[];
}
