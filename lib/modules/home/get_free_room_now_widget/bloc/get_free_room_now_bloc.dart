import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/booking_provider.dart';
import 'package:gorlaeus_bookings/data/date_time_provider.dart';
import 'package:gorlaeus_bookings/data/time_block.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/utils/room_overview_mapper.dart';
import 'package:gorlaeus_bookings/utils/time_block_extensions.dart';

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

  final RoomsOverviewMapper _mapper = const RoomsOverviewMapper();
  final Random _random = Random();

  // TODO: unit tests

  Stream<GetFreeRoomNowState> _handleGetFreeRoomNowSearchEvent() async* {
    List<String>? currentFreeRooms;
    String? currentFreeRoom;

    if (state is GetFreeRoomNowReadyState) {
      currentFreeRooms = (state as GetFreeRoomNowReadyState).freeRooms;
      currentFreeRoom = (state as GetFreeRoomNowReadyState).freeRoom;
    }

    yield GetFreeRoomNowBusyState(freeRoom: currentFreeRoom);

    if (currentFreeRooms == null) {
      // TODO: weekend state
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

        final Map<String, Iterable<TimeBlock?>> bookingsOverview =
            _mapper.mapToRoomsOverview(bookings);

        final List<String> freeRooms = bookingsOverview.keys
            .where((String key) =>
                bookingsOverview[key]?.any((TimeBlock? timeBlock) =>
                    timeBlock?.overlapsWith(timeBlockFromNowUntilEndOfDay) ==
                    true) ==
                false)
            .toList();

        // TODO: no rooms found state
        yield GetFreeRoomNowReadyState(
          freeRooms: freeRooms,
          freeRoom: freeRooms[_random.nextInt(freeRooms.length)],
        );
      } else {
        yield const GetFreeRoomNowErrorState();
      }
    } else {
      yield GetFreeRoomNowReadyState(
        freeRooms: currentFreeRooms,
        freeRoom: currentFreeRooms[_random.nextInt(currentFreeRooms.length)],
      );
    }
  }
}
