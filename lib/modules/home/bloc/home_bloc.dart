import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/app.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeBusyState()) {
    on<HomeInitEvent>((HomeInitEvent event, Emitter<HomeState> emit) =>
        emit(_handleInitEvent()));
    on<HomeThemeModeChangedEvent>(
        (HomeThemeModeChangedEvent event, Emitter<void> emit) =>
            _handleThemeModeChangedEvent(event));
    on<HomeDateChangedEvent>((HomeDateChangedEvent event,
            Emitter<HomeState> emit) =>
        emit((state as HomeReadyState).copyWith(newSelectedDate: event.date)));
  }

  HomeState _handleInitEvent() {
    final DateTime initialDate =
        getIt.get<DateTimeRepository>().getFirstWeekdayFromToday();
    return HomeReadyState(
      minimumDate: initialDate,
      maximumDate: initialDate.add(const Duration(days: 180)),
      selectedDate: initialDate,
    );
  }

  void _handleThemeModeChangedEvent(HomeThemeModeChangedEvent event) {
    App.themeNotifier.value = event.themeMode;
    getIt.get<SharedPreferencesRepository>().setThemeMode(event.themeMode);
  }
}
