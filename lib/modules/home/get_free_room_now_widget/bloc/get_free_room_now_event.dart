import 'package:equatable/equatable.dart';

abstract class GetFreeRoomNowEvent extends Equatable {
  const GetFreeRoomNowEvent();
}

class GetFreeRoomNowInitEvent extends GetFreeRoomNowEvent {
  const GetFreeRoomNowInitEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class GetFreeRoomNowSearchEvent extends GetFreeRoomNowEvent {
  const GetFreeRoomNowSearchEvent();

  @override
  List<Object?> get props => <Object?>[];
}
