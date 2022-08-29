import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_event.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._sharedPreferencesRepository)
      : super(const SettingsBusyState()) {
    on<SettingsInitEvent>(
        (SettingsInitEvent event, Emitter<SettingsState> emit) => emit.forEach(
            _handleInitEvent(),
            onData: (SettingsState state) => state));
    on<SettingsRoomSelectionChangedEvent>(
        (SettingsRoomSelectionChangedEvent event,
                Emitter<SettingsState> emit) =>
            emit(_handleSelectionChangedEvent(event)));
  }

  final SharedPreferencesRepository _sharedPreferencesRepository;

  Stream<SettingsState> _handleInitEvent() async* {
    final List<String> hiddenRooms =
        await _sharedPreferencesRepository.getHideRooms();
    yield SettingsReadyState(
      rooms: Rooms.all,
      selectedRooms:
          Rooms.all.whereNot((String room) => hiddenRooms.contains(room)),
    );
  }

  SettingsState _handleSelectionChangedEvent(
      SettingsRoomSelectionChangedEvent event) {
    final SettingsReadyState currentState = (state as SettingsReadyState);
    Iterable<String>? newSelectedRooms;
    if (event.isSelected == true) {
      newSelectedRooms = <String>[...currentState.selectedRooms, event.room];
    } else {
      newSelectedRooms = currentState.selectedRooms
          .whereNot((String room) => room == event.room);
    }
    return currentState.copyWith(newSelectedRooms);
  }
}
