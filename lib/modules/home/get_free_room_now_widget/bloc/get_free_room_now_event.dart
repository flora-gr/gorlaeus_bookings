import 'package:equatable/equatable.dart';

abstract class GetFreeRoomNowEvent extends Equatable {
  const GetFreeRoomNowEvent();
}

class GetFreeRoomNowSearchEvent extends GetFreeRoomNowEvent {
  const GetFreeRoomNowSearchEvent();

  @override
  List<Object?> get props => <Object?>[];
}
