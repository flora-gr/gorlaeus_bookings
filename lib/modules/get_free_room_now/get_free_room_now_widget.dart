import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:gorlaeus_bookings/widgets/loading_widget.dart';

class GetFreeRoomNowWidget extends StatefulWidget {
  const GetFreeRoomNowWidget(
    this._bloc, {
    super.key,
  });

  final GetFreeRoomNowBloc _bloc;

  @override
  State<GetFreeRoomNowWidget> createState() => _GetFreeRoomNowWidgetState();
}

class _GetFreeRoomNowWidgetState extends State<GetFreeRoomNowWidget> {
  late GetFreeRoomNowBloc _bloc;

  @override
  void initState() {
    _bloc = widget._bloc..add(const GetFreeRoomNowInitEvent());
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
                  Padding(
                    padding: Styles.leftPadding12,
                    child: Text(_getButtonText(state)),
                  ),
                  ButtonLoadingWidget(
                    showLoading: state is GetFreeRoomNowBusyState,
                  ),
                ],
              ),
            ),
            if (dataFetchedText != null)
              Padding(
                padding: Styles.topPadding12,
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
