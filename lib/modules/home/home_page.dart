import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_event.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_state.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/get_free_room_now_widget.dart';
import 'package:gorlaeus_bookings/resources/connection_urls.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';
import 'package:gorlaeus_bookings/resources/strings.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:gorlaeus_bookings/extensions/date_time_extensions.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:gorlaeus_bookings/utils/url_launcher_wrapper.dart';
import 'package:gorlaeus_bookings/widgets/item_box.dart';
import 'package:gorlaeus_bookings/widgets/loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage(
    this._bloc,
    this._urlLauncherWrapper,
    this._dateTimeRepository,
    this._bookingRepository,
    this._mapper, {
    super.key,
  });

  final HomeBloc _bloc;
  final UrlLauncherWrapper _urlLauncherWrapper;
  final DateTimeRepository _dateTimeRepository;
  final BookingRepository _bookingRepository;
  final RoomsOverviewMapper _mapper;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _bloc;
  late UrlLauncherWrapper _urlLauncherWrapper;

  @override
  void initState() {
    _bloc = widget._bloc..add(const HomeInitEvent());
    _urlLauncherWrapper = widget._urlLauncherWrapper;
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
        body: state is HomeReadyState
            ? SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: Styles.defaultPagePadding,
                    child: Column(
                      children: <Widget>[
                        ...<Widget>[
                          _buildBookingOverviewTile(state),
                          _buildGetMeAFreeRoomNowTile(state),
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.settingsPage),
                            child: const Text(
                              Strings.adjustSettings,
                              style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    color: Styles.secondaryColorSwatch,
                                    offset: Offset(0, -2),
                                  ),
                                ],
                                color: Colors.transparent,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                                decorationColor: Styles.secondaryColorSwatch,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: LoadingWidget(),
              ),
      ),
    );
  }

  void _openDisclaimerDialog() {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    final TextStyle defaultTextStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(fontSize: 14 * scaleFactor);
    final TextStyle linkTextStyle = defaultTextStyle.copyWith(
      color: Styles.secondaryColorSwatch,
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
                  ..onTap = () => _urlLauncherWrapper.launchUrl(
                        ConnectionUrls.zrsWebsiteLink,
                      ),
              ),
              TextSpan(
                text: Strings.disclaimerDialogText3,
                style: defaultTextStyle,
              ),
              TextSpan(
                text: Strings.disclaimerDialogText4,
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _urlLauncherWrapper.launchEmail(
                        ConnectionUrls.appDeveloperEmail,
                      ),
              ),
              TextSpan(
                text: Strings.disclaimerDialogText5,
                style: defaultTextStyle,
              ),
              TextSpan(
                text: Strings.disclaimerDialogText6,
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _urlLauncherWrapper.launchUrl(
                        ConnectionUrls.githubRepositoryLink,
                      ),
              ),
              TextSpan(
                text: Strings.disclaimerDialogText7,
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

  Widget _buildBookingOverviewTile(HomeReadyState state) {
    return ItemBox(
      title: Strings.bookingOverview,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...<Widget>[
            _buildDateContent(state),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(
                Routes.bookingOverviewPage,
                arguments: state.selectedDate,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(Strings.goToPageButtonText),
                  Icon(Icons.arrow_right)
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateContent(HomeReadyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 4),
        Text(
          '${Strings.dateToCheck} ${state.selectedDate.formatted}',
          style: Theme.of(context).textTheme.titleSmall,
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
                locale: const Locale('en', 'GB'),
                selectableDayPredicate: (DateTime date) => !date.isWeekendDay(),
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

  Widget _buildGetMeAFreeRoomNowTile(HomeState state) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      child: ItemBox(
        title: Strings.getMeAFreeRoom,
        child: GetFreeRoomNowWidget(
          widget._dateTimeRepository,
          widget._bookingRepository,
          widget._mapper,
        ),
      ),
    );
  }
}
