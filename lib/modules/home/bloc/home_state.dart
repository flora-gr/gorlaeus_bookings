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
  const HomeReadyState(this.date);

  final DateTime date;

  @override
  List<Object?> get props => <Object?>[date];
}
