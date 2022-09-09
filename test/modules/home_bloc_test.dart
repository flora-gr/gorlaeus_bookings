import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDateTimeRepository extends Mock implements DateTimeRepository {}

void main() {
  late DateTimeRepository dateTimeRepository;
  late HomeBloc sut;

  final DateTime today = DateTime.fromMillisecondsSinceEpoch(0);
  final DateTime maximumDate = today.add(const Duration(days: 100));
  final DateTime otherDay = DateTime.fromMillisecondsSinceEpoch(1);

  setUpAll(() {
    GetIt getIt = GetIt.instance;
    dateTimeRepository = MockDateTimeRepository();
    getIt.registerSingleton<DateTimeRepository>(dateTimeRepository);
  });

  setUp(() {
    when(() => dateTimeRepository.getFirstWeekdayFromToday())
        .thenAnswer((_) => today);
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
}
