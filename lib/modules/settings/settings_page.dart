import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_state.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';

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
    _bloc = widget.bloc;
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
        body: SingleChildScrollView(
          child: Padding(
            padding: Styles.defaultPagePadding,
            child: Column(
              children: <Widget>[],
            ),
          ),
        ),
      ),
    );
  }
}
