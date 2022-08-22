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

class BookingOverviewBookRoomEvent extends BookingOverviewEvent {
  const BookingOverviewBookRoomEvent(
    this.time,
    this.room,
  );

  final String time;
  final String room;

  @override
  List<Object?> get props => <Object?>[time, room];
}
