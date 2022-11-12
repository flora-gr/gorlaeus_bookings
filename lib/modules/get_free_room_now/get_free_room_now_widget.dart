import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_state.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
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
          title: AppLocalizations.of(context).getFreeRoomItemTitle,
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
                        AppLocalizations.of(context).favouriteRoomRadioButton,
                        selectedValue: true,
                      ),
                      _buildSearchFavouriteRadioButton(
                        state,
                        AppLocalizations.of(context).anyRoomRadioButton,
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
        visualDensity: VisualDensity.compact,
        activeColor: Theme.of(context).colorScheme.secondary,
        contentPadding: Styles.rightPadding8,
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
                textAlign: TextAlign.center,
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
        ? AppLocalizations.of(context).notAvailableInWeekendButton
        : hasDataFetchedText
            ? AppLocalizations.of(context).searchAgainButton
            : AppLocalizations.of(context).searchButton;
  }

  Widget? _getDataFetchedText(GetFreeRoomNowState state) {
    if (state is GetFreeRoomNowReadyState) {
      if (state is GetFreeRoomNowErrorState ||
          state is GetFreeRoomNowBusyState && state.fromErrorState) {
        return Text(AppLocalizations.of(context).getFreeRoomFailed);
      } else if (state.favouriteRoomIsFree != null) {
        return _getRichText(
          room: state.favouriteRoom!,
          favouriteRoomText1: AppLocalizations.of(context).favouriteRoomText1,
          favouriteRoomText2: state.favouriteRoomIsFree!
              ? null
              : AppLocalizations.of(context).favouriteRoomNotFree,
          nextBooking: state.nextBooking,
          isOnlyRoom: false,
        );
      } else if (state.freeRoom != null) {
        return _getRichText(
          favouriteRoomText1: state.freeRoom == state.favouriteRoom
              ? AppLocalizations.of(context).favouriteRoomText1
              : null,
          room: state.freeRoom!,
          nextBooking: state.nextBooking,
          isOnlyRoom: state.isOnlyRoom,
        );
      } else if (state is GetFreeRoomNowEmptyState) {
        return Text(AppLocalizations.of(context).noFreeRoomFound);
      }
    }
    return null;
  }

  Widget _getRichText({
    required String room,
    String? favouriteRoomText1,
    String? favouriteRoomText2,
    TimeBlock? nextBooking,
    bool? isOnlyRoom,
  }) {
    final TextStyle defaultTextStyle = Theme.of(context).textTheme.bodyText2!;
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(
            text:
                favouriteRoomText1 ?? AppLocalizations.of(context).roomIsFree1,
            style: defaultTextStyle,
          ),
          TextSpan(
            text: room.toRoomName(context),
            style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: favouriteRoomText2 ??
                AppLocalizations.of(context).roomIsFree2(
                  nextBooking?.startTimeString() ??
                      AppLocalizations.of(context).roomFreeNoEndTime,
                  isOnlyRoom!
                      ? AppLocalizations.of(context).roomFreeOnlyRoom
                      : '',
                ),
            style: defaultTextStyle,
          ),
          if (room == Rooms.room13 || room == Rooms.room21)
            TextSpan(
              text: AppLocalizations.of(context).notLectureRoom,
              style: defaultTextStyle.copyWith(fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
}
