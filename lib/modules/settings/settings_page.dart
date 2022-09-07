import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_event.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/widgets/loading_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
    this._bloc, {
    super.key,
  });

  final SettingsBloc _bloc;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsBloc _bloc;

  @override
  void initState() {
    _bloc = widget._bloc..add(const SettingsInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: _bloc,
      builder: (BuildContext context, SettingsState state) => Scaffold(
        appBar: AppBar(
          title: const Text(Strings.settingsPageTitle),
        ),
        body: state is SettingsReadyState
            ? _buildReadyBody(state)
            : const Center(
                child: LoadingWidget(),
              ),
        persistentFooterButtons: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _bloc.add(const SettingsSaveEvent());
                    Navigator.of(context).pop();
                  },
                  child: const Text(Strings.save),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildReadyBody(SettingsReadyState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: Styles.defaultPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ..._buildRoomSelection(state),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> _buildRoomSelection(SettingsReadyState state) {
    final int halfRoomCount = (state.rooms.length / 2).floor();
    final Iterable<String> firstHalfOfRooms = state.rooms.take(halfRoomCount);
    final Iterable<String> secondHalfOfRooms =
        state.rooms.toList().getRange(halfRoomCount, state.rooms.length);
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Text(
              Strings.selectRooms,
              style: Theme.of(context).textTheme.headline6,
            ),
            IconButton(
              onPressed: () => showDialog(
                builder: (_) => AlertDialog(
                  title: const Text(
                    Strings.selectRooms,
                  ),
                  content: const Text(Strings.selectRoomsInfoI),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(Strings.ok),
                    ),
                  ],
                ),
                context: context,
              ),
              icon: const Icon(
                Icons.info_outline,
                color: Styles.primaryColorSwatch,
              ),
            )
          ],
        ),
      ),
      Row(
        children: <Widget>[
          _buildCheckBoxColumn(firstHalfOfRooms, state.selectedRooms),
          _buildCheckBoxColumn(secondHalfOfRooms, state.selectedRooms),
        ],
      ),
    ];
  }

  Widget _buildCheckBoxColumn(
      Iterable<String> rooms, Iterable<String> selectedRooms) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rooms
            .map(
              (String room) => CheckboxListTile(
                title: Text(room.toRoomName()),
                controlAffinity: ListTileControlAffinity.leading,
                visualDensity: VisualDensity.compact,
                activeColor: Styles.secondaryColorSwatch,
                value: selectedRooms.contains(room),
                onChanged: (bool? value) => _bloc.add(
                  SettingsRoomSelectionChangedEvent(
                    room: room,
                    isSelected: value!,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
