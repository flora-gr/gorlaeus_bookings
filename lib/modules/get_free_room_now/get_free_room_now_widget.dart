import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/theme/styles.dart';
import 'package:gorlaeus_bookings/widgets/item_box.dart';
import 'package:gorlaeus_bookings/widgets/loading_widgets.dart';

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
        final Widget? dataFetchedText = _getDataFetchedText(state);
        return ItemBox(
          title: Strings.getFreeRoomItemTitle,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (state is GetFreeRoomNowReadyState &&
                    state.favouriteRoom != null)
                  Row(
                    children: <Widget>[
                      _buildSearchFavouriteRadioButton(
                        state,
                        Strings.favouriteRoomRadioButton,
                        selectedValue: true,
                      ),
                      _buildSearchFavouriteRadioButton(
                        state,
                        Strings.anyRoomRadioButton,
                        selectedValue: false,
                      ),
                    ],
                  ),
                _buildSearchButton(
                  state,
                  hasDataFetchedText: dataFetchedText != null,
                ),
                if (dataFetchedText != null)
                  Padding(
                    padding: Styles.topPadding12,
                    child: dataFetchedText,
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchFavouriteRadioButton(
    GetFreeRoomNowReadyState state,
    String title, {
    required bool selectedValue,
  }) {
    return Expanded(
      child: RadioListTile<bool>(
        activeColor: Theme.of(context).colorScheme.secondary,
        contentPadding: Styles.rightPadding4,
        title: Text(
          title,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        value: selectedValue,
        groupValue: state.favouriteRoomSearchSelected,
        onChanged: (bool? value) => _bloc.add(
          GetFreeRoomNowRadioButtonChangedEvent(
            favouriteRoomSearchSelected: value!,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton(
    GetFreeRoomNowState state, {
    required bool hasDataFetchedText,
  }) {
    return ElevatedButton(
      onPressed: state is GetFreeRoomNowWeekendState
          ? null
          : () => _bloc.add(const GetFreeRoomNowSearchEvent()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: Styles.leftPadding12,
              child: Text(
                _getButtonText(
                  state,
                  hasDataFetchedText: hasDataFetchedText,
                ),
              ),
            ),
          ),
          ButtonLoadingWidget(
            showLoading: state is GetFreeRoomNowBusyState,
          ),
        ],
      ),
    );
  }

  String _getButtonText(
    GetFreeRoomNowState state, {
    required bool hasDataFetchedText,
  }) {
    return state is GetFreeRoomNowWeekendState
        ? Strings.notAvailableInWeekendButton
        : hasDataFetchedText
            ? Strings.searchAgainButton
            : Strings.searchButton;
  }

  Widget? _getDataFetchedText(GetFreeRoomNowState state) {
    final TextStyle defaultTextStyle = Theme.of(context).textTheme.bodyText2!;
    if (state is GetFreeRoomNowReadyState) {
      if (state.favouriteRoomIsFree != null) {
        return Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: Strings.favouriteRoomMayBeFree1,
                style: defaultTextStyle,
              ),
              TextSpan(
                text: state.favouriteRoom!.toRoomName(),
                style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              if (state.favouriteRoomIsFree!)
                TextSpan(
                  text: Strings.roomIsFree2(
                    state.nextBooking?.startTimeString(),
                    isOnlyRoom: false,
                  ),
                  style: defaultTextStyle,
                )
              else
                TextSpan(
                  text: Strings.favouriteRoomNotFree,
                  style: defaultTextStyle,
                ),
              if (state.favouriteRoom == Rooms.room13 ||
                  state.favouriteRoom == Rooms.room21)
                TextSpan(
                  text: Strings.notLectureRoom,
                  style: defaultTextStyle.copyWith(fontStyle: FontStyle.italic),
                ),
            ],
          ),
        );
      } else if (state.freeRoom != null) {
        return Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: Strings.roomIsFree1,
                style: defaultTextStyle,
              ),
              TextSpan(
                text: state.freeRoom!.toRoomName(),
                style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: Strings.roomIsFree2(
                  state.nextBooking?.startTimeString(),
                  isOnlyRoom: state.isOnlyRoom!,
                ),
                style: defaultTextStyle,
              ),
              if (state.freeRoom == Rooms.room13 ||
                  state.freeRoom == Rooms.room21)
                TextSpan(
                  text: Strings.notLectureRoom,
                  style: defaultTextStyle.copyWith(fontStyle: FontStyle.italic),
                ),
            ],
          ),
        );
      } else if (state is GetFreeRoomNowEmptyState) {
        return const Text(Strings.noFreeRoomFound);
      } else if (state is GetFreeRoomNowErrorState) {
        return const Text(Strings.getFreeRoomFailed);
      }
    }
    return null;
  }
}
