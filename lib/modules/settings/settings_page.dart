import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_event.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/theme/styles.dart';
import 'package:gorlaeus_bookings/widgets/loading_widgets.dart';

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
            title: Text(AppLocalizations.of(context).settingsPageTitle),
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
                      Navigator.of(context).pop(true);
                    },
                    child: Text(AppLocalizations.of(context).saveButton),
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
            ..._buildFavouriteRoomSection(state)
          ],
        ),
      ),
    );
  }

  Iterable<Widget> _buildRoomSelectionSection(SettingsReadyState state) {
    final int halfRoomCount = (Rooms.all.length / 2).floor() + 1;
    final Iterable<String> firstHalfOfRooms = Rooms.all.take(halfRoomCount);
    final Iterable<String> secondHalfOfRooms =
        Rooms.all.toList().getRange(halfRoomCount, Rooms.all.length);
    return <Widget>[
      OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildHeaderWithInfoI(
            title: AppLocalizations.of(context).selectRoomsTitle,
            dialogText: AppLocalizations.of(context).selectRoomsInfoI,
          ),
          OutlinedButton(
            onPressed: () => _bloc.add(
              const SettingsAllRoomsSelectionChangedEvent(),
            ),
            child: Text(
              state.selectedRooms.length == Rooms.all.length
                  ? AppLocalizations.of(context).deselectAll
                  : AppLocalizations.of(context).selectAll,
            ),
          ),
        ],
      ),
      Padding(
        padding: Styles.topPadding12,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildCheckBoxColumn(firstHalfOfRooms, state),
                _buildCheckBoxColumn(secondHalfOfRooms, state),
              ],
            ),
            Padding(
              padding: Styles.padding8,
              child: Text(
                AppLocalizations.of(context).notLectureRooms,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildCheckBoxColumn(
      Iterable<String> rooms, SettingsReadyState state) {
    final TextStyle favouriteRoomTextStyle = Theme.of(context)
        .textTheme
        .subtitle1!
        .copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w600);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rooms
            .map(
              (String room) => CheckboxListTile(
                title: Text(
                  room.toRoomName(context),
                  style: state.favouriteRoom == room
                      ? favouriteRoomTextStyle
                      : null,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                visualDensity: VisualDensity.compact,
                activeColor: Theme.of(context).colorScheme.secondary,
                value: state.selectedRooms.contains(room) ||
                    state.favouriteRoom == room,
                onChanged: state.favouriteRoom == room
                    ? (bool? value) => _showCannotDeselectDialog()
                    : (bool? value) => _bloc.add(
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

  Iterable<Widget> _buildFavouriteRoomSection(SettingsReadyState state) {
    final Map<String, String?> items = <String, String?>{
      AppLocalizations.of(context).favouriteRoomNone: null
    };
    for (String room in Rooms.all) {
      items[room.toRoomName(context)] = room;
    }
    return <Widget>[
      Padding(
        padding: Styles.topPadding12,
        child: _buildHeaderWithInfoI(
          title: AppLocalizations.of(context).favouriteRoomTitle,
          dialogText: AppLocalizations.of(context).favouriteRoomInfoI,
        ),
      ),
      Padding(
        padding: Styles.padding8,
        child: ConstrainedBox(
          constraints: Styles.smallerWidthConstraint,
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                isDense: true,
                items: items.keys
                    .map(
                      (String itemName) => DropdownMenuItem<String?>(
                        value: items[itemName],
                        child: _buildDropdownItem(itemName),
                      ),
                    )
                    .toList(),
                selectedItemBuilder: (BuildContext context) => items.keys
                    .map(
                      (String itemName) => _buildDropdownItem(itemName),
                    )
                    .toList(),
                onChanged: (String? value) {
                  _bloc.add(
                    SettingsFavouriteSelectionChangedEvent(room: value),
                  );
                },
                value: state.favouriteRoom,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildDropdownItem(String itemName) {
    return Padding(
      padding: Styles.leftPadding12,
      child: Text(
        itemName,
        style: itemName == AppLocalizations.of(context).favouriteRoomNone
            ? Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontStyle: FontStyle.italic)
            : null,
      ),
    );
  }

  void _showCannotDeselectDialog() {
    showDialog(
      builder: (_) => AlertDialog(
        scrollable: true,
        title: Text(AppLocalizations.of(context).favouriteRoomTitle),
        content: Text(AppLocalizations.of(context).favouriteRoomCannotDeselect),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).okButton),
          ),
        ],
      ),
      context: context,
    );
  }

  Widget _buildHeaderWithInfoI({
    required String title,
    required String dialogText,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Theme.of(context).textTheme.headline6!.color,
          ),
          onPressed: () => showDialog(
            builder: (_) => AlertDialog(
              scrollable: true,
              title: Text(title),
              content: Text(dialogText),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context).okButton),
                ),
              ],
            ),
            context: context,
          ),
        ),
      ],
    );
  }
}
