import 'package:equatable/equatable.dart';
import 'package:gorlaeus_bookings/data/models/booking_entry.dart';

abstract class GetFreeRoomNowState extends Equatable {
  const GetFreeRoomNowState();
}

class GetFreeRoomNowWeekendState extends GetFreeRoomNowState {
  const GetFreeRoomNowWeekendState();

  @override
  List<Object?> get props => <Object?>[];
}

class GetFreeRoomNowReadyState extends GetFreeRoomNowState {
  const GetFreeRoomNowReadyState({
    this.bookings,
    this.freeRoom,
  });

  final List<BookingEntry>? bookings;
  final String? freeRoom;

  @override
  List<Object?> get props => <Object?>[bookings, freeRoom];
}

class GetFreeRoomNowBusyState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowBusyState({
    List<BookingEntry>? bookings,
    String? freeRoom,
  }) : super(bookings: bookings, freeRoom: freeRoom);

  @override
  List<Object?> get props => <Object?>[...super.props];
}

class GetFreeRoomNowErrorState extends GetFreeRoomNowState {
  const GetFreeRoomNowErrorState();

  @override
  List<Object?> get props => <Object?>[];
}

class GetFreeRoomNowEmptyState extends GetFreeRoomNowState {
  const GetFreeRoomNowEmptyState();

  @override
  List<Object?> get props => <Object?>[];
}