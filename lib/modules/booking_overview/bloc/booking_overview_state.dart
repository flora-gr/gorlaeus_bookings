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
  const BookingOverviewReadyState(this.bookings);

  final List<BookingEntry> bookings;

  @override
  List<Object?> get props => <Object?>[bookings];
}

class BookingOverviewErrorState extends BookingOverviewState {
  const BookingOverviewErrorState();

  @override
  List<Object?> get props => <Object?>[];
}
