import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_event.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
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
      builder: (BuildContext context, SettingsState state) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadyBody(SettingsReadyState state) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: Styles.defaultPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ..._buildRoomSelectionSection(state),
            ..._buildEmailNameSection(state),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> _buildRoomSelectionSection(SettingsReadyState state) {
    final int halfRoomCount = (state.rooms.length / 2).floor() + 1;
    final Iterable<String> firstHalfOfRooms = state.rooms.take(halfRoomCount);
    final Iterable<String> secondHalfOfRooms =
        state.rooms.toList().getRange(halfRoomCount, state.rooms.length);
    return <Widget>[
      _buildHeaderWithInfoI(
        title: Strings.selectRooms,
        dialogText: Strings.selectRoomsInfoI,
      ),
      Padding(
        padding: Styles.topPadding12,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildCheckBoxColumn(firstHalfOfRooms, state.selectedRooms),
                _buildCheckBoxColumn(secondHalfOfRooms, state.selectedRooms),
              ],
            ),
            const Padding(
              padding: Styles.verticalPadding8,
              child: Text(Strings.notLectureRooms),
            ),
          ],
        ),
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

  Iterable<Widget> _buildEmailNameSection(SettingsReadyState state) {
    return <Widget>[
      Padding(
        padding: Styles.topPadding12,
        child: _buildHeaderWithInfoI(
          title: Strings.setEmailName,
          dialogText: Strings.setEmailNameInfoI,
        ),
      ),
      Padding(
        padding: Styles.verticalPadding8,
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          initialValue: state.emailName ?? '',
          onChanged: (String value) => _bloc.add(
            SettingsEmailNameChangedEvent(emailName: value),
          ),
        ),
      ),
    ];
  }

  Widget _buildHeaderWithInfoI({
    required String title,
    required String dialogText,
  }) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        IconButton(
          onPressed: () => showDialog(
            builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(dialogText),
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
    );
  }
}
