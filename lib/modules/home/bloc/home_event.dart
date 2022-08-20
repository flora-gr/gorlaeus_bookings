import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeInitEvent extends HomeEvent {
  const HomeInitEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class HomeDateChangedEvent extends HomeEvent {
  const HomeDateChangedEvent(this.date);

  final DateTime date;

  @override
  List<Object?> get props => <Object?>[date];
}
