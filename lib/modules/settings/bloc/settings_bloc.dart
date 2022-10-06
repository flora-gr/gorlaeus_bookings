import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_event.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsBusyState()) {
    _sharedPreferencesRepository = getIt.get<SharedPreferencesRepository>();
    on<SettingsInitEvent>(
        (SettingsInitEvent event, Emitter<SettingsState> emit) => emit.forEach(
            _handleInitEvent(),
            onData: (SettingsState state) => state));
    on<SettingsRoomSelectionChangedEvent>(
        (SettingsRoomSelectionChangedEvent event,
                Emitter<SettingsState> emit) =>
            emit(_handleRoomSelectionChangedEvent(event)));
    on<SettingsSaveEvent>(
        (SettingsSaveEvent event, Emitter<SettingsState> emit) =>
            _handleSettingsSaveEvent());
  }

  late SharedPreferencesRepository _sharedPreferencesRepository;

  Stream<SettingsState> _handleInitEvent() async* {
    final List<String> hiddenRooms =
        await _sharedPreferencesRepository.getHiddenRooms();

    yield SettingsReadyState(
      selectedRooms:
          Rooms.all.whereNot((String room) => hiddenRooms.contains(room)),
    );
  }

  SettingsState _handleRoomSelectionChangedEvent(
      SettingsRoomSelectionChangedEvent event) {
    final SettingsReadyState currentState = (state as SettingsReadyState);
    Iterable<String>? newSelectedRooms;
    if (event.isSelected == true) {
      newSelectedRooms = <String>[...currentState.selectedRooms, event.room];
    } else {
      newSelectedRooms = currentState.selectedRooms
          .whereNot((String room) => room == event.room);
    }
    return currentState.copyWith(selectedRooms: newSelectedRooms);
  }

  void _handleSettingsSaveEvent() {
    final SettingsReadyState currentState = (state as SettingsReadyState);
    final Iterable<String> hiddenRooms = Rooms.all
        .whereNot((String room) => currentState.selectedRooms.contains(room));
    _sharedPreferencesRepository.setHiddenRooms(hiddenRooms.toList());
  }
}
