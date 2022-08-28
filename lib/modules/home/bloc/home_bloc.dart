import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/providers/date_time_provider.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._dateTimeProvider) : super(const HomeBusyState()) {
    on<HomeInitEvent>((HomeInitEvent event, Emitter<HomeState> emit) =>
        emit(_handleInitEvent()));
    on<HomeDateChangedEvent>((HomeDateChangedEvent event,
            Emitter<HomeState> emit) =>
        emit((state as HomeReadyState).copyWith(newSelectedDate: event.date)));
  }

  final DateTimeProvider _dateTimeProvider;

  HomeState _handleInitEvent() {
    final DateTime initialDate = _dateTimeProvider.getFirstWeekdayFromToday();
    return HomeReadyState(
      minimumDate: initialDate,
      maximumDate: initialDate.add(const Duration(days: 365)),
      selectedDate: initialDate,
    );
  }
}
