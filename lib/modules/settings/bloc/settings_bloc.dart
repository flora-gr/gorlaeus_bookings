import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_event.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsBusyState()) {}
}
