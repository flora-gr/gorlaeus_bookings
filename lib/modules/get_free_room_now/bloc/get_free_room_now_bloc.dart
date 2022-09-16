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
            emit(_handleGetFreeRoomInitEvent()));
    on<GetFreeRoomNowSearchEvent>(
        (GetFreeRoomNowSearchEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit.forEach(_handleGetFreeRoomNowSearchEvent(),
                onData: (GetFreeRoomNowState state) => state));
  }

  late DateTimeRepository _dateTimeRepository;

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
    bool? currentIsOnlyRoom;

    if (state is GetFreeRoomNowReadyState) {
      final GetFreeRoomNowReadyState readyState =
          state as GetFreeRoomNowReadyState;
      bookings = readyState.bookings;
      currentFreeRoom = readyState.freeRoom;
      currentIsOnlyRoom = readyState.isOnlyRoom;
    }

    yield GetFreeRoomNowBusyState(
      freeRoom: currentFreeRoom,
      isOnlyRoom: currentIsOnlyRoom,
    );

    final DateTime now = _dateTimeRepository.getCurrentDateTime();

    // TODO(fgroothuizen): fix bug where no new search is done when sharedprefs are changed to include more buildings
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
}
