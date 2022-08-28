import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/data/providers/booking_provider.dart';
import 'package:gorlaeus_bookings/data/providers/date_time_provider.dart';
import 'package:gorlaeus_bookings/data/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/utils/date_time_extensions.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:gorlaeus_bookings/utils/time_block_extensions.dart';

class GetFreeRoomNowBloc
    extends Bloc<GetFreeRoomNowEvent, GetFreeRoomNowState> {
  GetFreeRoomNowBloc(
    this._dateTimeProvider,
    this._bookingProvider,
  ) : super(const GetFreeRoomNowReadyState()) {
    on<GetFreeRoomNowInitEvent>(
        (GetFreeRoomNowInitEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit(_handleGetFreeRoomInitEvent()));
    on<GetFreeRoomNowSearchEvent>(
        (GetFreeRoomNowSearchEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit.forEach(_handleGetFreeRoomNowSearchEvent(),
                onData: (GetFreeRoomNowState state) => state));
  }

  final DateTimeProvider _dateTimeProvider;
  final BookingProvider _bookingProvider;

  final RoomsOverviewMapper _mapper = const RoomsOverviewMapper();
  final Random _random = Random();

  GetFreeRoomNowState _handleGetFreeRoomInitEvent() {
    if (_dateTimeProvider.getCurrentDateTime().isWeekendDay()) {
      return const GetFreeRoomNowWeekendState();
    } else {
      return const GetFreeRoomNowReadyState();
    }
  }

  Stream<GetFreeRoomNowState> _handleGetFreeRoomNowSearchEvent() async* {
    List<String>? currentFreeRooms;
    String? currentFreeRoom;

    if (state is GetFreeRoomNowReadyState) {
      currentFreeRooms = (state as GetFreeRoomNowReadyState).freeRooms;
      currentFreeRoom = (state as GetFreeRoomNowReadyState).freeRoom;
    }

    yield GetFreeRoomNowBusyState(freeRoom: currentFreeRoom);

    if (currentFreeRooms == null) {
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

        if (freeRooms.isNotEmpty) {
          yield GetFreeRoomNowReadyState(
            freeRooms: freeRooms,
            freeRoom: freeRooms[_random.nextInt(freeRooms.length)],
          );
        } else {
          yield const GetFreeRoomNowEmptyState();
        }
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
