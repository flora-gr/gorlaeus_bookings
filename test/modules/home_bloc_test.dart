import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDateTimeRepository extends Mock implements DateTimeRepository {}

class MockSharedPreferencesRepository extends Mock
    implements SharedPreferencesRepository {}

void main() {
  late DateTimeRepository dateTimeRepository;
  late SharedPreferencesRepository sharedPreferencesRepository;
  late HomeBloc sut;

  final DateTime today = DateTime.fromMillisecondsSinceEpoch(0);
  final DateTime maximumDate = today.add(const Duration(days: 180));
  final DateTime otherDay = DateTime.fromMillisecondsSinceEpoch(1);

  setUpAll(() {
    GetIt getIt = GetIt.instance;
    dateTimeRepository = MockDateTimeRepository();
    sharedPreferencesRepository = MockSharedPreferencesRepository();
    getIt.registerSingleton<DateTimeRepository>(dateTimeRepository);
    getIt.registerSingleton<SharedPreferencesRepository>(
        sharedPreferencesRepository);
    registerFallbackValue(ThemeMode.system);
  });

  setUp(() {
    when(() => dateTimeRepository.getFirstWeekdayFromToday())
        .thenAnswer((_) => today);
    when(() => sharedPreferencesRepository.setThemeMode(any()))
        .thenAnswer((_) async => true);
    sut = HomeBloc();
  });

  blocTest<HomeBloc, HomeState>(
    'Initialization emits ready state with date of today selected',
    build: () => sut,
    act: (HomeBloc bloc) => bloc.add(const HomeInitEvent()),
    expect: () => <HomeState>[
      HomeReadyState(
        minimumDate: today,
        maximumDate: maximumDate,
        selectedDate: today,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'Changing date emits ready state with the new date selected',
    build: () => sut,
    seed: () => HomeReadyState(
      minimumDate: today,
      maximumDate: maximumDate,
      selectedDate: today,
    ),
    act: (HomeBloc bloc) => bloc.add(HomeDateChangedEvent(otherDay)),
    expect: () => <HomeState>[
      HomeReadyState(
        minimumDate: today,
        maximumDate: maximumDate,
        selectedDate: otherDay,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'Changing theme mode saves theme mode in shared preferences',
    build: () => sut,
    act: (HomeBloc bloc) =>
        bloc.add(const HomeThemeModeChangedEvent(ThemeMode.dark)),
    verify: (_) {
      verify(() => sharedPreferencesRepository.setThemeMode(ThemeMode.dark))
          .called(1);
    },
  );
}
