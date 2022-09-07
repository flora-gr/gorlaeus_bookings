import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_event.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferencesRepository extends Mock
    implements SharedPreferencesRepository {}

void main() {
  late MockSharedPreferencesRepository sharedPreferencesRepository;
  late SettingsBloc sut;

  final List<String> hiddenRooms =
      Rooms.all.where((String room) => room != Rooms.room1).toList();

  setUp(() {
    sharedPreferencesRepository = MockSharedPreferencesRepository();
    when(() => sharedPreferencesRepository.getHiddenRooms())
        .thenAnswer((_) async => hiddenRooms);
    when(() => sharedPreferencesRepository.setHiddenRooms(any()))
        .thenAnswer((_) async => true);
    sut = SettingsBloc(sharedPreferencesRepository);
  });

  blocTest<SettingsBloc, SettingsState>(
    'Initialization emits ready state with non-hidden room selected',
    build: () => sut,
    act: (SettingsBloc bloc) => bloc.add(const SettingsInitEvent()),
    expect: () => <dynamic>[
      predicate(
        (SettingsReadyState state) =>
            state.rooms == Rooms.all &&
            state.selectedRooms.length == 1 &&
            state.selectedRooms.single == Rooms.room1,
      ),
    ],
  );

  const SettingsReadyState seedState = SettingsReadyState(
    rooms: Rooms.all,
    selectedRooms: <String>[Rooms.room1],
  );

  blocTest<SettingsBloc, SettingsState>(
    'Selecting a room emits ready state with updated room selection',
    build: () => sut,
    seed: () => seedState,
    act: (SettingsBloc bloc) => bloc.add(
      const SettingsRoomSelectionChangedEvent(
        room: Rooms.room2,
        isSelected: true,
      ),
    ),
    expect: () => <dynamic>[
      predicate(
        (SettingsReadyState state) =>
            state.rooms == Rooms.all &&
            state.selectedRooms.length == 2 &&
            state.selectedRooms.contains(Rooms.room2),
      ),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'Unselecting a room emits ready state with updated room selection',
    build: () => sut,
    seed: () => seedState,
    act: (SettingsBloc bloc) => bloc.add(
      const SettingsRoomSelectionChangedEvent(
        room: Rooms.room1,
        isSelected: false,
      ),
    ),
    expect: () => <dynamic>[
      predicate((SettingsReadyState state) =>
          state.rooms == Rooms.all && state.selectedRooms.isEmpty),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'Saving settings saves rooms to shared preferences',
    build: () => sut,
    seed: () => seedState,
    act: (SettingsBloc bloc) => bloc.add(const SettingsSaveEvent()),
    verify: (_) {
      verify(() => sharedPreferencesRepository.setHiddenRooms(hiddenRooms))
          .called(1);
    },
  );
}
