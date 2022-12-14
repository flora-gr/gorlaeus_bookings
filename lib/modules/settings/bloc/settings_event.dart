import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInitEvent extends SettingsEvent {
  const SettingsInitEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class SettingsRoomSelectionChangedEvent extends SettingsEvent {
  const SettingsRoomSelectionChangedEvent({
    required this.room,
    required this.isSelected,
  });

  final String room;
  final bool isSelected;

  @override
  List<Object?> get props => <Object?>[room, isSelected];
}

class SettingsFavouriteSelectionChangedEvent extends SettingsEvent {
  const SettingsFavouriteSelectionChangedEvent({
    required this.room,
  });

  final String? room;

  @override
  List<Object?> get props => <Object?>[room];
}

class SettingsAllRoomsSelectionChangedEvent extends SettingsEvent {
  const SettingsAllRoomsSelectionChangedEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class SettingsSaveEvent extends SettingsEvent {
  const SettingsSaveEvent();

  @override
  List<Object?> get props => <Object?>[];
}
