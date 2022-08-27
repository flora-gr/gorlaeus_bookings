import 'package:equatable/equatable.dart';

abstract class GetFreeRoomNowState extends Equatable {
  const GetFreeRoomNowState();
}

class GetFreeRoomNowReadyState extends GetFreeRoomNowState {
  const GetFreeRoomNowReadyState({this.freeRoom});

  final String? freeRoom;

  @override
  List<Object?> get props => <Object?>[];
}

class GetFreeRoomNowBusyState extends GetFreeRoomNowState {
  const GetFreeRoomNowBusyState();

  @override
  List<Object?> get props => <Object?>[];
}

class GetFreeRoomNowErrorState extends GetFreeRoomNowState {
  const GetFreeRoomNowErrorState();

  @override
  List<Object?> get props => <Object?>[];
}
