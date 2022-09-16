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
    _dateTimeRepository = getIt.get<DateTimeRepository>();
    on<GetFreeRoomNowInitEvent>(
        (GetFreeRoomNowInitEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit(_handleInitEvent()));
    on<GetFreeRoomNowSearchEvent>(
        (GetFreeRoomNowSearchEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit.forEach(_handleSearchEvent(),
                onData: (GetFreeRoomNowState state) => state));
    on<GetFreeRoomNowSharedPreferencesChangedEvent>(
        (GetFreeRoomNowSharedPreferencesChangedEvent event,
                Emitter<GetFreeRoomNowState> emit) =>
            emit(_handleSharedPreferencesChangedEvent()));
  }

  late DateTimeRepository _dateTimeRepository;

  final Random _random = Random();

  GetFreeRoomNowState _handleInitEvent() {
    if (_dateTimeRepository.getCurrentDateTime().isWeekendDay()) {
      return const GetFreeRoomNowWeekendState();
    } else {
      return const GetFreeRoomNowReadyState();
    }
  }

  Stream<GetFreeRoomNowState> _handleSearchEvent() async* {
    List<BookingEntry>? bookings;
    String? currentFreeRoom;
    TimeBlock? currentNextBooking;
    bool? currentIsOnlyRoom;

    if (state is GetFreeRoomNowReadyState) {
      final GetFreeRoomNowReadyState currentState =
          state as GetFreeRoomNowReadyState;
      bookings = currentState.bookings;
      currentFreeRoom = currentState.freeRoom;
      currentNextBooking = currentState.nextBooking;
      currentIsOnlyRoom = currentState.isOnlyRoom;
    }

    yield GetFreeRoomNowBusyState(
      freeRoom: currentFreeRoom,
      nextBooking: currentNextBooking,
      isOnlyRoom: currentIsOnlyRoom,
    );

    final DateTime now = _dateTimeRepository.getCurrentDateTime();

    if (bookings == null) {
      List<BookingEntry>? bookingsResponse;
      try {
        bookingsResponse =
            await getIt.get<BookingRepository>().getBookings(now);
      } on Exception {
        yield const GetFreeRoomNowErrorState();
      }

      if (bookingsResponse != null) {
        bookings = bookingsResponse;
      }
    }

    final Map<String, Iterable<TimeBlock?>>? timeBlocksPerRoom =
        await getIt.get<RoomsOverviewMapper>().mapTimeBlocks(bookings);

    if (timeBlocksPerRoom != null) {
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

      final List<String> freeRooms = timeBlocksPerRoom.keys
          .where((String key) =>
              timeBlocksPerRoom[key]?.any((TimeBlock? timeBlock) =>
                  timeBlock?.overlapsWith(timeBlockFromNowUntilHourFromNow) ==
                  true) ==
              false)
          .toList();

      if (freeRooms.isNotEmpty) {
        final String freeRoom = freeRooms[_random.nextInt(freeRooms.length)];
        final List<TimeBlock?> bookingsForFreeRooms =
            timeBlocksPerRoom[freeRoom]!.sort();
        final TimeBlock? nextBooking = bookingsForFreeRooms.firstWhereOrNull(
            ((TimeBlock? bookingTime) =>
                bookingTime!.isAfter(timeBlockFromNowUntilHourFromNow)));

        yield GetFreeRoomNowReadyState(
          bookings: bookings,
          freeRoom: freeRoom,
          nextBooking: nextBooking,
          isOnlyRoom: freeRooms.length == 1,
        );
      } else {
        yield const GetFreeRoomNowEmptyState();
      }
    } else {
      yield const GetFreeRoomNowErrorState();
    }
  }

  GetFreeRoomNowState _handleSharedPreferencesChangedEvent() {
    if (state is GetFreeRoomNowReadyState) {
      final GetFreeRoomNowReadyState currentState =
          state as GetFreeRoomNowReadyState;
      return GetFreeRoomNowReadyState(
        freeRoom: currentState.freeRoom,
        nextBooking: currentState.nextBooking,
        isOnlyRoom: false,
      );
    } else if (state is GetFreeRoomNowEmptyState) {
      return const GetFreeRoomNowReadyState();
    }
    return state;
  }
}
