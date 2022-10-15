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
    this.favouriteRoom,
    this.favouriteRoomSearchSelected = true,
    this.favouriteRoomIsFree,
    this.freeRoom,
    this.nextBooking,
    this.isOnlyRoom,
  });

  final Map<String, Iterable<TimeBlock?>>? timeBlocksPerRoom;
  final String? favouriteRoom;
  final bool favouriteRoomSearchSelected;
  final bool? favouriteRoomIsFree;
  final String? freeRoom;
  final TimeBlock? nextBooking;
  final bool? isOnlyRoom;

  GetFreeRoomNowReadyState copyWith(
      {required bool favouriteRoomSearchSelected}) {
    return GetFreeRoomNowReadyState(
      timeBlocksPerRoom: timeBlocksPerRoom,
      favouriteRoom: favouriteRoom,
      favouriteRoomSearchSelected: favouriteRoomSearchSelected,
      favouriteRoomIsFree: favouriteRoomIsFree,
      freeRoom: freeRoom,
      nextBooking: nextBooking,
      isOnlyRoom: isOnlyRoom,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        timeBlocksPerRoom,
        favouriteRoom,
        favouriteRoomSearchSelected,
        favouriteRoomIsFree,
        freeRoom,
        nextBooking,
        isOnlyRoom,
      ];
}

class GetFreeRoomNowBusyState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowBusyState({
    String? favouriteRoom,
    required bool favouriteRoomSearchSelected,
    bool? favouriteRoomIsFree,
    String? freeRoom,
    TimeBlock? nextBooking,
    bool? isOnlyRoom,
    required this.fromErrorState,
  }) : super(
          favouriteRoom: favouriteRoom,
          favouriteRoomSearchSelected: favouriteRoomSearchSelected,
          favouriteRoomIsFree: favouriteRoomIsFree,
          freeRoom: freeRoom,
          nextBooking: nextBooking,
          isOnlyRoom: isOnlyRoom,
        );

  final bool fromErrorState;

  @override
  List<Object?> get props => <Object?>[...super.props, fromErrorState];
}

class GetFreeRoomNowErrorState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowErrorState({
    String? favouriteRoom,
    required bool favouriteRoomSearchSelected,
  }) : super(
          favouriteRoom: favouriteRoom,
          favouriteRoomSearchSelected: favouriteRoomSearchSelected,
        );

  @override
  List<Object?> get props => <Object?>[...super.props];
}

class GetFreeRoomNowEmptyState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowEmptyState({
    required Map<String, Iterable<TimeBlock?>>? timeBlocksPerRoom,
    String? favouriteRoom,
    required bool favouriteRoomSearchSelected,
  }) : super(
          timeBlocksPerRoom: timeBlocksPerRoom,
          favouriteRoom: favouriteRoom,
          favouriteRoomSearchSelected: favouriteRoomSearchSelected,
        );

  @override
  List<Object?> get props => <Object?>[...super.props];
}
