import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_event.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:gorlaeus_bookings/utils/string_extensions.dart';
import 'package:gorlaeus_bookings/widgets/loading_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
    this.bloc, {
    super.key,
  });

  final SettingsBloc bloc;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsBloc _bloc;

  @override
  void initState() {
    _bloc = widget.bloc..add(const SettingsInitEvent());
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
            ? SingleChildScrollView(
                child: Padding(
                  padding: Styles.defaultPagePadding,
                  child: Column(
                    children: <Widget>[
                      ...state.rooms.map(
                        (String room) => CheckboxListTile(
                          title: Text(room.toRoomName()),
                          controlAffinity: ListTileControlAffinity.leading,
                          visualDensity: VisualDensity.compact,
                          activeColor: Styles.secondaryColorSwatch,
                          value: state.selectedRooms.contains(room),
                          onChanged: (bool? value) {
                            _bloc.add(
                              SettingsRoomSelectionChangedEvent(
                                room: room,
                                isSelected: value!,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
}
