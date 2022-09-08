import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._dateTimeRepository) : super(const HomeBusyState()) {
    on<HomeInitEvent>((HomeInitEvent event, Emitter<HomeState> emit) =>
        emit(_handleInitEvent()));
    on<HomeDateChangedEvent>((HomeDateChangedEvent event,
            Emitter<HomeState> emit) =>
        emit((state as HomeReadyState).copyWith(newSelectedDate: event.date)));
  }

  final DateTimeRepository _dateTimeRepository;

  HomeState _handleInitEvent() {
    final DateTime initialDate = _dateTimeRepository.getFirstWeekdayFromToday();
    return HomeReadyState(
      minimumDate: initialDate,
      maximumDate: initialDate.add(const Duration(days: 100)),
      selectedDate: initialDate,
    );
  }
}
