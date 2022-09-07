import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';

class GetFreeRoomNowWidget extends StatefulWidget {
  const GetFreeRoomNowWidget(
    this._dateTimeRepository,
    this._bookingRepository,
    this._mapper, {
    super.key,
  });

  final DateTimeRepository _dateTimeRepository;
  final BookingRepository _bookingRepository;
  final RoomsOverviewMapper _mapper;

  @override
  State<GetFreeRoomNowWidget> createState() => _GetFreeRoomNowWidgetState();
}

class _GetFreeRoomNowWidgetState extends State<GetFreeRoomNowWidget> {
  late GetFreeRoomNowBloc _bloc;

  @override
  void initState() {
    _bloc = GetFreeRoomNowBloc(
      widget._dateTimeRepository,
      widget._bookingRepository,
      widget._mapper,
    )..add(const GetFreeRoomNowInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetFreeRoomNowBloc, GetFreeRoomNowState>(
      bloc: _bloc,
      builder: (BuildContext context, GetFreeRoomNowState state) {
        final String? dataFetchedText = _getDataFetchedText(state);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: state is GetFreeRoomNowWeekendState
                  ? null
                  : () => _bloc.add(const GetFreeRoomNowSearchEvent()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_getButtonText(state)),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: state is GetFreeRoomNowBusyState
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            if (dataFetchedText != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(dataFetchedText),
              )
          ],
        );
      },
    );
  }

  String _getButtonText(GetFreeRoomNowState state) {
    return state is GetFreeRoomNowWeekendState
        ? Strings.notAvailableInWeekend
        : state is GetFreeRoomNowErrorState ||
                state is GetFreeRoomNowReadyState && state.freeRoom != null
            ? Strings.tryAgain
            : Strings.search;
  }

  String? _getDataFetchedText(GetFreeRoomNowState state) {
    if (state is GetFreeRoomNowReadyState && state.freeRoom != null) {
      return Strings.roomIsFree(
        state.freeRoom!.toRoomName(),
      );
    } else if (state is GetFreeRoomNowEmptyState) {
      return Strings.noRoomFound;
    } else if (State is GetFreeRoomNowErrorState) {
      return Strings.getFreeRoomFailed;
    }
    return null;
  }
}
