import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/extensions/date_time_extensions.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_event.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/get_free_room_now_widget.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';
import 'package:gorlaeus_bookings/resources/connection_urls.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';
import 'package:gorlaeus_bookings/theme/styles.dart';
import 'package:gorlaeus_bookings/utils/url_launcher_wrapper.dart';
import 'package:gorlaeus_bookings/widgets/item_box.dart';
import 'package:gorlaeus_bookings/widgets/loading_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage(
    this._bloc,
    this._getFreeRoomNowBloc, {
    super.key,
  });

  final HomeBloc _bloc;
  final GetFreeRoomNowBloc _getFreeRoomNowBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _bloc;
  late UrlLauncherWrapper _urlLauncherWrapper;

  @override
  void initState() {
    _bloc = widget._bloc..add(const HomeInitEvent());
    _urlLauncherWrapper = getIt.get<UrlLauncherWrapper>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).homePageTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                isLightTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
              onPressed: () {
                _bloc.add(
                  HomeThemeModeChangedEvent(
                    isLightTheme ? ThemeMode.dark : ThemeMode.light,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _openDisclaimerDialog,
            ),
          ],
        ),
        body: state is HomeReadyState
            ? _buildReadyBody(state)
            : const Center(
                child: LoadingWidget(),
              ),
      ),
    );
  }

  void _openDisclaimerDialog() {
    final TextStyle defaultTextStyle = Theme.of(context).textTheme.subtitle1!;
    final TextStyle linkTextStyle = defaultTextStyle.copyWith(
      color: Theme.of(context).colorScheme.secondary,
      decoration: TextDecoration.underline,
    );
    showDialog(
      builder: (_) => AlertDialog(
        scrollable: true,
        title: Text(
          AppLocalizations.of(context).disclaimerDialogTitle,
        ),
        content: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context).disclaimerDialogText1,
                    style: defaultTextStyle,
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).disclaimerDialogText2,
                    style: linkTextStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _urlLauncherWrapper.launchUrl(
                            ConnectionUrls.zrsWebsiteLink,
                          ),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).disclaimerDialogText3,
                    style: defaultTextStyle,
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).disclaimerDialogText4,
                    style: linkTextStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _urlLauncherWrapper.launchEmail(
                            ConnectionUrls.appDeveloperEmail,
                          ),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).disclaimerDialogText5,
                    style: defaultTextStyle,
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).disclaimerDialogText6,
                    style: linkTextStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _urlLauncherWrapper.launchUrl(
                            ConnectionUrls.githubRepositoryLink,
                          ),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).disclaimerDialogText7,
                    style: defaultTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
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

  Widget _buildReadyBody(HomeReadyState state) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: Styles.defaultPagePadding,
          child: Column(
            children: <Widget>[
              ...<Widget>[
                _buildBookingOverviewItem(state),
                GetFreeRoomNowWidget(
                  widget._getFreeRoomNowBloc,
                ),
                _buildGoToSettingsButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingOverviewItem(HomeReadyState state) {
    return ItemBox(
      title: AppLocalizations.of(context).bookingOverviewItemTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ..._buildDateContent(state),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed(
              Routes.bookingOverviewPage,
              arguments: state.selectedDate,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(AppLocalizations.of(context).goToBookingsButton),
                const Icon(Icons.arrow_right),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Iterable<Widget> _buildDateContent(HomeReadyState state) {
    return <Widget>[
      Padding(
        padding: Styles.topPadding4,
        child: Text(
          AppLocalizations.of(context)
              .dateToCheck(state.selectedDate.formatted),
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        child: OutlinedButton(
          onPressed: () async {
            final DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: state.selectedDate,
              firstDate: state.minimumDate,
              lastDate: state.maximumDate,
              locale: Locale(AppLocalizations.of(context).localeName),
              selectableDayPredicate: (DateTime date) => !date.isWeekendDay(),
            );
            if (newDate != null) {
              _bloc.add(HomeDateChangedEvent(newDate));
            }
          },
          child: Text(AppLocalizations.of(context).dateSelectionButton),
        ),
      ),
    ];
  }

  Widget _buildGoToSettingsButton() {
    return Padding(
      padding: Styles.padding8,
      child: TextButton(
        onPressed: () async {
          final bool? hasChangedSettings =
              await Navigator.of(context).pushNamed(Routes.settingsPage);
          if (hasChangedSettings == true) {
            widget._getFreeRoomNowBloc
                .add(const GetFreeRoomNowSharedPreferencesChangedEvent());
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.check_box_outlined),
            Padding(
              padding: Styles.horizontalPadding8,
              child: Text(
                AppLocalizations.of(context).adjustSettingsButton,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
