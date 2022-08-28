import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInitEvent extends SettingsEvent {
  const SettingsInitEvent();

  @override
  List<Object?> get props => <Object?>[];
}
