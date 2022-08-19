import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeBusyState extends HomeState {
  const HomeBusyState();

  @override
  List<Object?> get props => <Object?>[];
}

class HomeReadyState extends HomeState {
  const HomeReadyState({
    required this.minimumDate,
    required this.maximumDate,
    required this.selectedDate,
  });

  final DateTime minimumDate;
  final DateTime maximumDate;
  final DateTime selectedDate;

  HomeReadyState copyWith({required DateTime newSelectedDate}) {
    return HomeReadyState(
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      selectedDate: newSelectedDate,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        minimumDate,
        maximumDate,
        selectedDate,
      ];
}
