import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';
import 'package:gorlaeus_bookings/resources/connection_urls.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:gorlaeus_bookings/utils/date_time_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) => Scaffold(
        appBar: AppBar(
          title: const Text(Strings.homePageTitle),
          actions: <Widget>[
            IconButton(
              onPressed: _openDisclaimerDialog,
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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

  void _openDisclaimerDialog() {
    final TextStyle? defaultTextStyle = Theme.of(context).textTheme.bodyText2;
    final TextStyle? linkTextStyle = defaultTextStyle?.copyWith(
      color: Styles.linkTextColor,
      decoration: TextDecoration.underline,
    );
    showDialog(
      builder: (_) => AlertDialog(
        title: const Text(
          Strings.disclaimerDialogTitle,
        ),
        content: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: Strings.disclaimerDialogText1,
                style: defaultTextStyle,
              ),
              TextSpan(
                text: Strings.disclaimerDialogText2,
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(
                      ConnectionUrls.zrsWebsiteLink,
                      mode: LaunchMode.externalApplication,
                    );
                  },
              ),
              TextSpan(
                text: Strings.disclaimerDialogText3,
                style: defaultTextStyle,
              ),
              TextSpan(
                text: Strings.disclaimerDialogText4,
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(
                      ConnectionUrls.githubRepositoryLink,
                      mode: LaunchMode.externalApplication,
                    );
                  },
              ),
              TextSpan(
                text: Strings.disclaimerDialogText5,
                style: defaultTextStyle,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(Strings.ok),
          ),
        ],
      ),
      context: context,
    );
  }

  Widget _buildDateContent(HomeReadyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${Strings.dateToCheck} ${state.selectedDate.formatted}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: OutlinedButton(
            onPressed: () async {
              final DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: state.selectedDate,
                firstDate: state.minimumDate,
                lastDate: state.maximumDate,
                locale: const Locale('nl', 'NL'),
                selectableDayPredicate: (DateTime date) =>
                    date.weekday != DateTime.saturday &&
                    date.weekday != DateTime.sunday,
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
