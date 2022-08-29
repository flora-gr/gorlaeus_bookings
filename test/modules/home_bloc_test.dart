import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/data/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';
import 'package:mocktail/mocktail.dart';

class MockDateTimeRepository extends Mock implements DateTimeRepository {}

void main() {
  late DateTimeRepository dateTimeRepository;
  late HomeBloc sut;

  final DateTime today = DateTime.fromMillisecondsSinceEpoch(0);
  final DateTime nextYear = today.add(const Duration(days: 365));
  final DateTime otherDay = DateTime.fromMillisecondsSinceEpoch(1);

  setUp(() {
    dateTimeRepository = MockDateTimeRepository();
    when(() => dateTimeRepository.getFirstWeekdayFromToday())
        .thenAnswer((_) => today);
    sut = HomeBloc(dateTimeRepository);
  });

  blocTest<HomeBloc, HomeState>(
    'Initialization emits ready state with date of today selected',
    build: () => sut,
    act: (HomeBloc bloc) => bloc.add(const HomeInitEvent()),
    expect: () => <HomeState>[
      HomeReadyState(
        minimumDate: today,
        maximumDate: nextYear,
        selectedDate: today,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'Changing date emits ready state with the new date selected',
    build: () => sut,
    seed: () => HomeReadyState(
      minimumDate: today,
      maximumDate: nextYear,
      selectedDate: today,
    ),
    act: (HomeBloc bloc) => bloc.add(HomeDateChangedEvent(otherDay)),
    expect: () => <HomeState>[
      HomeReadyState(
        minimumDate: today,
        maximumDate: nextYear,
        selectedDate: otherDay,
      ),
    ],
  );
}
