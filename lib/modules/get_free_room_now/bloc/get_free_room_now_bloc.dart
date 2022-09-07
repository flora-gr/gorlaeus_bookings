import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/extensions/date_time_extensions.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';

class GetFreeRoomNowBloc
    extends Bloc<GetFreeRoomNowEvent, GetFreeRoomNowState> {
  GetFreeRoomNowBloc(
    this._dateTimeRepository,
    this._bookingRepository,
    this._mapper,
  ) : super(const GetFreeRoomNowReadyState()) {
    on<GetFreeRoomNowInitEvent>(
        (GetFreeRoomNowInitEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit(_handleGetFreeRoomInitEvent()));
    on<GetFreeRoomNowSearchEvent>(
        (GetFreeRoomNowSearchEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit.forEach(_handleGetFreeRoomNowSearchEvent(),
                onData: (GetFreeRoomNowState state) => state));
  }

  final DateTimeRepository _dateTimeRepository;
  final BookingRepository _bookingRepository;
  final RoomsOverviewMapper _mapper;
  final Random _random = Random();

  GetFreeRoomNowState _handleGetFreeRoomInitEvent() {
    if (_dateTimeRepository.getCurrentDateTime().isWeekendDay()) {
      return const GetFreeRoomNowWeekendState();
    } else {
      return const GetFreeRoomNowReadyState();
    }
  }

  Stream<GetFreeRoomNowState> _handleGetFreeRoomNowSearchEvent() async* {
    List<BookingEntry>? bookings;
    String? currentFreeRoom;

    if (state is GetFreeRoomNowReadyState) {
      bookings = (state as GetFreeRoomNowReadyState).bookings;
      currentFreeRoom = (state as GetFreeRoomNowReadyState).freeRoom;
    }

    yield GetFreeRoomNowBusyState(freeRoom: currentFreeRoom);

    final DateTime now = _dateTimeRepository.getCurrentDateTime();

    if (bookings == null) {
      final List<BookingEntry>? bookingsResponse =
          await _bookingRepository.getBookings(now);

      if (bookingsResponse != null) {
        bookings = bookingsResponse;
      }
    }

    final Map<String, Iterable<TimeBlock?>>? bookingsOverview =
        await _mapper.mapToRoomsOverview(bookings);

    if (bookingsOverview != null) {
      final TimeBlock timeBlockFromNowUntilEndOfDay = TimeBlock(
        startTime: TimeOfDay(
          hour: now.hour,
          minute: now.minute,
        ),
        endTime: const TimeOfDay(hour: 18, minute: 0),
      );

      final List<String> freeRooms = bookingsOverview.keys
          .where((String key) =>
              bookingsOverview[key]?.any((TimeBlock? timeBlock) =>
                  timeBlock?.overlapsWith(timeBlockFromNowUntilEndOfDay) ==
                  true) ==
              false)
          .toList();

      if (freeRooms.isNotEmpty) {
        yield GetFreeRoomNowReadyState(
          bookings: bookings,
          freeRoom: freeRooms[_random.nextInt(freeRooms.length)],
        );
      } else {
        yield const GetFreeRoomNowEmptyState();
      }
    } else {
      yield const GetFreeRoomNowErrorState();
    }
  }
}
