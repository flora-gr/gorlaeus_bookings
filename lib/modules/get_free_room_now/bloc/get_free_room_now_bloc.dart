import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/extensions/date_time_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_of_day_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';

class GetFreeRoomNowBloc
    extends Bloc<GetFreeRoomNowEvent, GetFreeRoomNowState> {
  GetFreeRoomNowBloc() : super(const GetFreeRoomNowReadyState()) {
    _dateTimeRepository = getIt.get<DateTimeRepository>();
    _sharedPreferencesRepository = getIt.get<SharedPreferencesRepository>();
    on<GetFreeRoomNowInitEvent>((GetFreeRoomNowInitEvent event,
            Emitter<GetFreeRoomNowState> emit) async =>
        emit(await _handleInitEvent()));
    on<GetFreeRoomNowSearchEvent>(
        (GetFreeRoomNowSearchEvent event, Emitter<GetFreeRoomNowState> emit) =>
            emit.forEach(_handleSearchEvent(),
                onData: (GetFreeRoomNowState state) => state));
    on<GetFreeRoomNowRadioButtonChangedEvent>(
        (GetFreeRoomNowRadioButtonChangedEvent event,
                Emitter<GetFreeRoomNowState> emit) =>
            emit((state as GetFreeRoomNowReadyState).copyWith(
                favouriteRoomSearchSelected:
                    event.favouriteRoomSearchSelected)));
    on<GetFreeRoomNowSharedPreferencesChangedEvent>(
        (GetFreeRoomNowSharedPreferencesChangedEvent event,
                Emitter<GetFreeRoomNowState> emit) async =>
            emit(await _handleSharedPreferencesChangedEvent()));
  }

  late DateTimeRepository _dateTimeRepository;
  late SharedPreferencesRepository _sharedPreferencesRepository;

  final Random _random = Random();

  Future<GetFreeRoomNowState> _handleInitEvent() async {
    if (_dateTimeRepository.getCurrentDateTime().isWeekendDay()) {
      return const GetFreeRoomNowWeekendState();
    } else {
      final String? favouriteRoom =
          await _sharedPreferencesRepository.getFavouriteRoom();
      return GetFreeRoomNowReadyState(favouriteRoom: favouriteRoom);
    }
  }

  Stream<GetFreeRoomNowState> _handleSearchEvent() async* {
    final GetFreeRoomNowReadyState currentState =
        state as GetFreeRoomNowReadyState;

    Map<String, Iterable<TimeBlock?>>? timeBlocksPerRoom =
        currentState.timeBlocksPerRoom;
    String? favouriteRoom = currentState.favouriteRoom;

    yield GetFreeRoomNowBusyState(
      favouriteRoom: favouriteRoom,
      favouriteRoomSearchSelected: currentState.favouriteRoomSearchSelected,
      freeRoom: currentState.freeRoom,
      nextBooking: currentState.nextBooking,
      isOnlyRoom: currentState.isOnlyRoom,
    );

    try {
      final DateTime now = _dateTimeRepository.getCurrentDateTime();

      if (timeBlocksPerRoom == null) {
        final List<BookingEntry>? bookingsResponse =
            await getIt.get<BookingRepository>().getBookings(now);
        timeBlocksPerRoom = await getIt
            .get<RoomsOverviewMapper>()
            .mapTimeBlocks(bookingsResponse);
        favouriteRoom = await _sharedPreferencesRepository.getFavouriteRoom();
      }

      if (timeBlocksPerRoom != null) {
        final TimeBlock timeBlockToCheck = _getTimeBlockToCheck(now);
        final List<String> freeRooms = timeBlocksPerRoom.keys
            .where((String key) => !timeBlocksPerRoom![key]!.any(
                (TimeBlock? timeBlock) =>
                    timeBlock?.overlapsWith(timeBlockToCheck) == true))
            .toList();

        if (currentState.favouriteRoomSearchSelected && favouriteRoom != null) {
          if (freeRooms.contains(favouriteRoom)) {
            final List<TimeBlock?> bookingsForFavouriteRoom =
                timeBlocksPerRoom[favouriteRoom]!.sort();
            final TimeBlock? nextBooking = bookingsForFavouriteRoom
                .firstWhereOrNull(((TimeBlock? bookingTime) =>
                    bookingTime!.isAfter(timeBlockToCheck)));
            yield GetFreeRoomNowFavouriteRoomState(
              timeBlocksPerRoom: timeBlocksPerRoom,
              favouriteRoom: favouriteRoom,
              favouriteRoomSearchSelected: true,
              isFree: true,
              nextBooking: nextBooking,
            );
          } else {
            yield GetFreeRoomNowFavouriteRoomState(
              timeBlocksPerRoom: timeBlocksPerRoom,
              favouriteRoom: favouriteRoom,
              favouriteRoomSearchSelected: true,
              isFree: false,
            );
          }
        } else {
          if (freeRooms.isNotEmpty) {
            final String freeRoom =
                freeRooms[_random.nextInt(freeRooms.length)];
            final List<TimeBlock?> bookingsForFreeRoom =
                timeBlocksPerRoom[freeRoom]!.sort();
            final TimeBlock? nextBooking = bookingsForFreeRoom.firstWhereOrNull(
                ((TimeBlock? bookingTime) =>
                    bookingTime!.isAfter(timeBlockToCheck)));

            yield GetFreeRoomNowReadyState(
              timeBlocksPerRoom: timeBlocksPerRoom,
              favouriteRoom: favouriteRoom,
              favouriteRoomSearchSelected:
                  currentState.favouriteRoomSearchSelected,
              freeRoom: freeRoom,
              nextBooking: nextBooking,
              isOnlyRoom: freeRooms.length == 1,
            );
          } else {
            yield GetFreeRoomNowEmptyState(
              favouriteRoom: favouriteRoom,
              favouriteRoomSearchSelected:
                  currentState.favouriteRoomSearchSelected,
            );
          }
        }
      } else {
        yield GetFreeRoomNowErrorState(
          favouriteRoom: favouriteRoom,
          favouriteRoomSearchSelected: currentState.favouriteRoomSearchSelected,
        );
      }
    } on Exception {
      yield GetFreeRoomNowErrorState(
        favouriteRoom: favouriteRoom,
        favouriteRoomSearchSelected: currentState.favouriteRoomSearchSelected,
      );
    }
  }

  TimeBlock _getTimeBlockToCheck(DateTime now) {
    final TimeOfDay hourFromNow = TimeOfDay(
      hour: now.hour + 1,
      minute: now.minute,
    );
    final TimeOfDay endTime = BookingTimes.time1.startTime.isAfter(hourFromNow)
        ? BookingTimes.time1.endTime
        : hourFromNow;
    return TimeBlock(
      startTime: TimeOfDay(
        hour: now.hour,
        minute: now.minute,
      ),
      endTime: endTime,
    );
  }

  Future<GetFreeRoomNowState> _handleSharedPreferencesChangedEvent() async {
    final String? favouriteRoom =
        await _sharedPreferencesRepository.getFavouriteRoom();
    if (state is GetFreeRoomNowReadyState) {
      return GetFreeRoomNowReadyState(favouriteRoom: favouriteRoom);
    }
    return state;
  }
}
