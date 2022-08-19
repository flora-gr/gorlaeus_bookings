import 'package:equatable/equatable.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';

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
  final List<BookingEntry> bookings;

  @override
  List<Object?> get props => <Object?>[date, bookings];
}

class BookingOverviewErrorState extends BookingOverviewState {
  const BookingOverviewErrorState();

  @override
  List<Object?> get props => <Object?>[];
}
