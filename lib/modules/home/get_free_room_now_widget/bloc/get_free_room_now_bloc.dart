import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/booking_provider.dart';
import 'package:gorlaeus_bookings/data/date_time_provider.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';

class GetFreeRoomNowBloc
    extends Bloc<GetFreeRoomNowEvent, GetFreeRoomNowState> {
  GetFreeRoomNowBloc(
    this._dateTimeProvider,
    this._bookingProvider,
  ) : super(const GetFreeRoomNowReadyState()) {
    on<GetFreeRoomNowSearchEvent>(
      (GetFreeRoomNowSearchEvent event, Emitter<GetFreeRoomNowState> emit) =>
          emit.forEach(_handleGetFreeRoomNowSearchEvent(),
              onData: (GetFreeRoomNowState state) => state),
    );
  }

  final DateTimeProvider _dateTimeProvider;
  final BookingProvider _bookingProvider;

  Stream<GetFreeRoomNowState> _handleGetFreeRoomNowSearchEvent() async* {
    yield const GetFreeRoomNowBusyState();

    final DateTime now = _dateTimeProvider.getCurrentDateTime();
    final List<BookingEntry>? bookings =
        await _bookingProvider.getBookings(now);

    if (bookings != null) {
      final TimeBlock timeBlockFromNowUntilEndOfDay = TimeBlock(
        startTime: TimeOfDay(
          hour: now.hour,
          minute: now.minute,
        ),
        endTime: const TimeOfDay(hour: 18, minute: 0),
      );

      // TODO: get actual free room for this time block
      yield const GetFreeRoomNowReadyState(freeRoom: Rooms.room1);
    } else {
      yield const GetFreeRoomNowErrorState();
    }
  }
}
