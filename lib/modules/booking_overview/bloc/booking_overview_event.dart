import 'package:equatable/equatable.dart';

abstract class BookingOverviewEvent extends Equatable {
  const BookingOverviewEvent();
}

class BookingOverviewInitEvent extends BookingOverviewEvent {
  const BookingOverviewInitEvent();

  @override
  List<Object?> get props => <Object?>[];
}
