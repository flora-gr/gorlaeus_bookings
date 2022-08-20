import 'package:equatable/equatable.dart';

abstract class BookingOverviewEvent extends Equatable {
  const BookingOverviewEvent();
}

class BookingOverviewInitEvent extends BookingOverviewEvent {
  const BookingOverviewInitEvent(this.date);

  final DateTime date;

  @override
  List<Object?> get props => <Object?>[date];
}
