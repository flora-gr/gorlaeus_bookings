import 'package:equatable/equatable.dart';
import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/data/models/time_block.dart';

abstract class BookingOverviewState extends Equatable {
  const BookingOverviewState();
}

class BookingOverviewBusyState extends BookingOverviewState {
  const BookingOverviewBusyState();

  @override
  List<Object?> get props => <Object?>[];
}

class BookingOverviewReadyState extends BookingOverviewState {
  const BookingOverviewReadyState({
    required this.date,
    required this.bookings,
  });

  final DateTime date;
  final Map<String, Iterable<TimeBlock?>> bookings;

  @override
  List<Object?> get props => <Object?>[date, bookings];
}

class BookingOverviewErrorState extends BookingOverviewState {
  const BookingOverviewErrorState();

  @override
  List<Object?> get props => <Object?>[];
}
