import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/repositories/shared_preferences_provider.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_event.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._sharedPreferencesProvider)
      : super(const SettingsBusyState()) {
    on<SettingsInitEvent>(
        (SettingsInitEvent event, Emitter<SettingsState> emit) =>
            emit(_handleInitEvent()));
  }

  final SharedPreferencesRepository _sharedPreferencesProvider;

  SettingsState _handleInitEvent() {
    return const SettingsReadyState(
      rooms: <String>[],
      selectedRooms: <String>[],
    );
  }
}
