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
              Text(
                Strings.homePageText,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              if (state is HomeReadyState) ...<Widget>[
                _buildDateContent(state),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    Routes.bookingOverviewPage,
                    arguments: state.selectedDate,
                  ),
                  child: IntrinsicWidth(
                    child: Row(
                      children: const <Widget>[
                        Text(Strings.goToPageButtonText),
                        Icon(Icons.arrow_right)
                      ],
                    ),
                  ),
                ),
              ] else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateContent(HomeReadyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('${Strings.dateToCheck} ${state.selectedDate.formatted}'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: OutlinedButton(
            onPressed: () async {
              final DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: state.selectedDate,
                firstDate: state.minimumDate,
                lastDate: state.maximumDate,
              );
              if (newDate != null) {
                _bloc.add(HomeDateChangedEvent(newDate));
              }
            },
            child: const Text(Strings.chooseADate),
          ),
        ),
      ],
    );
  }
}
