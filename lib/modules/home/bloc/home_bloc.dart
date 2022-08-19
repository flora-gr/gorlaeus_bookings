import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/date_time_provider.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._dateTimeProvider) : super(const HomeBusyState()) {
    on<HomeInitEvent>((event, emit) => emit(_handleInitEvent()));
    on<HomeDateChangedEvent>((event, emit) =>
        emit((state as HomeReadyState).copyWith(newSelectedDate: event.date)));
  }

  final DateTimeProvider _dateTimeProvider;

  HomeState _handleInitEvent() {
    final DateTime currentDate = _dateTimeProvider.getCurrentDateTime();
    return HomeReadyState(
      minimumDate: currentDate,
      maximumDate: currentDate.add(Duration(days: 365)),
      selectedDate: currentDate,
    );
  }
}
