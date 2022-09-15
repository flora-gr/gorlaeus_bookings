import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';

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
    required this.timeIfToday,
    required this.bookingsPerRoom,
  });

  final DateTime date;
  final TimeOfDay? timeIfToday;
  final Map<String, Iterable<BookingEntry?>> bookingsPerRoom;

  @override
  List<Object?> get props => <Object?>[date, timeIfToday, bookingsPerRoom];
}

class BookingOverviewErrorState extends BookingOverviewState {
  const BookingOverviewErrorState();

  @override
  List<Object?> get props => <Object?>[];
}
