import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/data/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/data/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/home/get_free_room_now_widget/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/utils/string_extensions.dart';

class GetFreeRoomNowWidget extends StatefulWidget {
  const GetFreeRoomNowWidget(
    this.dateTimeProvider,
    this.bookingProvider, {
    super.key,
  });

  final DateTimeRepository dateTimeProvider;
  final BookingRepository bookingProvider;

  @override
  State<GetFreeRoomNowWidget> createState() => _GetFreeRoomNowWidgetState();
}

class _GetFreeRoomNowWidgetState extends State<GetFreeRoomNowWidget> {
  late GetFreeRoomNowBloc _bloc;

  @override
  void initState() {
    _bloc = GetFreeRoomNowBloc(
      widget.dateTimeProvider,
      widget.bookingProvider,
    )..add(const GetFreeRoomNowInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetFreeRoomNowBloc, GetFreeRoomNowState>(
      bloc: _bloc,
      builder: (BuildContext context, GetFreeRoomNowState state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElevatedButton(
            onPressed: state is GetFreeRoomNowWeekendState
                ? null
                : () => _bloc.add(const GetFreeRoomNowSearchEvent()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  state is GetFreeRoomNowWeekendState
                      ? Strings.notAvailableInWeekend
                      : state is GetFreeRoomNowErrorState ||
                              state is GetFreeRoomNowReadyState &&
                                  state.freeRoom != null
                          ? Strings.tryAgain
                          : Strings.search,
                ),
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
          if (state is GetFreeRoomNowReadyState && state.freeRoom != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                Strings.roomIsFree(
                  state.freeRoom!.toRoomName(),
                ),
              ),
            )
          else if (state is GetFreeRoomNowEmptyState)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(Strings.noRoomFound),
            )
          else if (state is GetFreeRoomNowErrorState)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(Strings.getFreeRoomFailed),
            ),
        ],
      ),
    );
  }
}
