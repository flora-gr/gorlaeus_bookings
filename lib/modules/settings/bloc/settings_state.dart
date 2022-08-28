import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsBusyState extends SettingsState {
  const SettingsBusyState();

  @override
  List<Object?> get props => <Object?>[];
}
