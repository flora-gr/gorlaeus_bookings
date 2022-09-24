import 'package:equatable/equatable.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';

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
    this.timeBlocksPerRoom,
    this.freeRoom,
    this.nextBooking,
    this.isOnlyRoom,
  });

  final Map<String, Iterable<TimeBlock?>>? timeBlocksPerRoom;
  final String? freeRoom;
  final TimeBlock? nextBooking;
  final bool? isOnlyRoom;

  @override
  List<Object?> get props => <Object?>[
        timeBlocksPerRoom,
        freeRoom,
        nextBooking,
        isOnlyRoom,
      ];
}

class GetFreeRoomNowBusyState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowBusyState({
    String? freeRoom,
    TimeBlock? nextBooking,
    bool? isOnlyRoom,
  }) : super(
          freeRoom: freeRoom,
          nextBooking: nextBooking,
          isOnlyRoom: isOnlyRoom,
        );

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
