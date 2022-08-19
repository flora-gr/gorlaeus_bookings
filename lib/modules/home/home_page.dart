import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/utils/date_time_extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage(
    this.bloc, {
    Key? key,
  }) : super(key: key);

  final HomeBloc bloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _bloc;

  @override
  void initState() {
    _bloc = widget.bloc..add(const HomeInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) => Scaffold(
        appBar: AppBar(
          title: const Text(Strings.homePageTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(Strings.homePageText),
              const SizedBox(height: 12),
              if (state is HomeReadyState)
                Text('${Strings.dateToCheck} ${state.date.formatted}')
              else
                const CircularProgressIndicator(),
            ],
          ),
        ),
        floatingActionButton: state is HomeReadyState
            ? FloatingActionButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  Routes.bookingOverviewPage,
                  arguments: state.date,
                ),
                tooltip: Strings.goToPageToolTip,
                child: const Icon(Icons.control_point),
              )
            : null,
      ),
    );
  }
}
