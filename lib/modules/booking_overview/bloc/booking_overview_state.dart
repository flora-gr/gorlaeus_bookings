import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';

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
    required this.roomsOverview,
  });

  final DateTime date;
  final TimeOfDay? timeIfToday;
  final Map<String, Iterable<TimeBlock?>> roomsOverview;

  @override
  List<Object?> get props => <Object?>[date, timeIfToday, roomsOverview];
}

class BookingOverviewErrorState extends BookingOverviewState {
  const BookingOverviewErrorState();

  @override
  List<Object?> get props => <Object?>[];
}
