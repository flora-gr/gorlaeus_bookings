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
    this.freeRoom,
    this.nextBooking,
    this.isOnlyRoom,
  });

  final Map<String, Iterable<TimeBlock?>>? timeBlocksPerRoom;
  final String? favouriteRoom;
  final bool favouriteRoomSearchSelected;
  final String? freeRoom;
  final TimeBlock? nextBooking;
  final bool? isOnlyRoom;

  GetFreeRoomNowReadyState copyWith(
      {required bool favouriteRoomSearchSelected}) {
    return GetFreeRoomNowReadyState(
      timeBlocksPerRoom: timeBlocksPerRoom,
      favouriteRoom: favouriteRoom,
      favouriteRoomSearchSelected: favouriteRoomSearchSelected,
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
        freeRoom,
        nextBooking,
        isOnlyRoom,
      ];
}

class GetFreeRoomNowBusyState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowBusyState({
    String? favouriteRoom,
    bool favouriteRoomSearchSelected = true,
    String? freeRoom,
    TimeBlock? nextBooking,
    bool? isOnlyRoom,
  }) : super(
          favouriteRoom: favouriteRoom,
          favouriteRoomSearchSelected: favouriteRoomSearchSelected,
          freeRoom: freeRoom,
          nextBooking: nextBooking,
          isOnlyRoom: isOnlyRoom,
        );

  @override
  List<Object?> get props => <Object?>[...super.props];
}

class GetFreeRoomNowFavouriteRoomState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowFavouriteRoomState({
    Map<String, Iterable<TimeBlock?>>? timeBlocksPerRoom,
    String? favouriteRoom,
    bool favouriteRoomSearchSelected = true,
    TimeBlock? nextBooking,
    required this.isFree,
  }) : super(
          timeBlocksPerRoom: timeBlocksPerRoom,
          favouriteRoom: favouriteRoom,
          favouriteRoomSearchSelected: favouriteRoomSearchSelected,
          nextBooking: nextBooking,
        );

  final bool isFree;

  @override
  List<Object?> get props => <Object?>[...super.props, isFree];
}

class GetFreeRoomNowErrorState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowErrorState({
    String? favouriteRoom,
    bool favouriteRoomSearchSelected = true,
  }) : super(
          favouriteRoom: favouriteRoom,
          favouriteRoomSearchSelected: favouriteRoomSearchSelected,
        );

  @override
  List<Object?> get props => <Object?>[...super.props];
}

class GetFreeRoomNowEmptyState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowEmptyState({
    String? favouriteRoom,
    bool favouriteRoomSearchSelected = true,
  }) : super(
          favouriteRoom: favouriteRoom,
          favouriteRoomSearchSelected: favouriteRoomSearchSelected,
        );

  @override
  List<Object?> get props => <Object?>[...super.props];
}
