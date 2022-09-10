import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/extensions/date_time_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';

class GetFreeRoomNowBloc
    extends Bloc<GetFreeRoomNowEvent, GetFreeRoomNowState> {
  GetFreeRoomNowBloc() : super(const GetFreeRoomNowReadyState()) {
    _bookingRepository = getIt.get<BookingRepository>();
    _dateTimeRepository = getIt.get<DateTimeRepository>();
    _mapper = getIt.get<RoomsOverviewMapper>();
    on<GetFreeRoomNowInitEvent>(
        (GetFreeRoomNowInitEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit(_handleGetFreeRoomInitEvent()));
    on<GetFreeRoomNowSearchEvent>(
        (GetFreeRoomNowSearchEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit.forEach(_handleGetFreeRoomNowSearchEvent(),
                onData: (GetFreeRoomNowState state) => state));
  }

  late BookingRepository _bookingRepository;
  late DateTimeRepository _dateTimeRepository;
  late RoomsOverviewMapper _mapper;

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

    final Map<String, Iterable<TimeBlock?>>? roomsOverview =
        await _mapper.mapToRoomsOverview(bookings);

    if (roomsOverview != null) {
      final TimeBlock timeBlockFromNowUntilHourFromNow = TimeBlock(
        startTime: TimeOfDay(
          hour: now.hour,
          minute: now.minute,
        ),
        endTime: TimeOfDay(
          hour: now.hour + 1,
          minute: now.minute,
        ),
      );

      final List<String> freeRooms = roomsOverview.keys
          .where((String key) =>
              roomsOverview[key]?.any((TimeBlock? timeBlock) =>
                  timeBlock?.overlapsWith(timeBlockFromNowUntilHourFromNow) ==
                  true) ==
              false)
          .toList();

      if (freeRooms.isNotEmpty) {
        final String freeRoom = freeRooms[_random.nextInt(freeRooms.length)];
        final List<TimeBlock?> bookingsForFreeRooms =
            roomsOverview[freeRoom]!.sort();
        final TimeBlock? nextBooking = bookingsForFreeRooms.firstWhereOrNull(
            ((TimeBlock? bookingTime) =>
                bookingTime!.isAfter(timeBlockFromNowUntilHourFromNow)));

        yield GetFreeRoomNowReadyState(
          bookings: bookings,
          freeRoom: freeRoom,
          nextBooking: nextBooking,
        );
      } else {
        yield const GetFreeRoomNowEmptyState();
      }
    } else {
      yield const GetFreeRoomNowErrorState();
    }
  }
}
