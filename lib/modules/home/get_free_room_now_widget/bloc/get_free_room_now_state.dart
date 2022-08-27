import 'package:equatable/equatable.dart';

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
    this.freeRooms,
    this.freeRoom,
  });

  final List<String>? freeRooms;
  final String? freeRoom;

  @override
  List<Object?> get props => <Object?>[freeRooms, freeRoom];
}

class GetFreeRoomNowBusyState extends GetFreeRoomNowReadyState {
  const GetFreeRoomNowBusyState({
    List<String>? freeRooms,
    String? freeRoom,
  }) : super(freeRooms: freeRooms, freeRoom: freeRoom);

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
