import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart';

import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/booking_overview_page.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/home_page.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/settings_page.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:gorlaeus_bookings/utils/url_launcher_wrapper.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart' as di;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const GorlaeusBookingApp());
}

class GorlaeusBookingApp extends StatelessWidget {
  const GorlaeusBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gorlaeus Bookings',
      theme: _themeData,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const <Locale>[
        Locale('nl', 'NL'),
        Locale('en', 'GB'),
      ],
      initialRoute: Routes.homePage,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  static final ThemeData _themeData = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Styles.primaryColorSwatch,
    ).copyWith(
      secondary: Styles.secondaryColorSwatch,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide().copyWith(
          color: Styles.outlinedButtonBorderColor,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Styles.secondaryColorSwatch,
      ),
    ),
    textTheme: const TextTheme().copyWith(
      bodyText2: TextStyle(
        fontSize: Styles.defaultFontSize,
        height: Styles.defaultFontHeight,
      ),
    ),
    scaffoldBackgroundColor: Styles.backgroundColor,
  );

  MaterialPageRoute<void> _onGenerateRoute(RouteSettings settings) {
    debugPrint(settings.toString());
    switch (settings.name) {
      case Routes.bookingOverviewPage:
        return _getRoute(
          BookingOverviewPage(
            BookingOverviewBloc(
              getIt.get<BookingRepository>(),
              getIt.get<DateTimeRepository>(),
              getIt.get<RoomsOverviewMapper>(),
              getIt.get<UrlLauncherWrapper>(),
            ),
            settings.arguments as DateTime,
          ),
          settings,
        );
      case Routes.settingsPage:
        return _getRoute(
          SettingsPage(
            SettingsBloc(getIt.get<SharedPreferencesRepository>()),
          ),
          settings,
          fullscreenDialog: true,
        );
      case Routes.homePage:
      default:
        return _getRoute(
          HomePage(
            HomeBloc(
              getIt.get<DateTimeRepository>(),
            ),
            getIt.get<UrlLauncherWrapper>(),
            getIt.get<DateTimeRepository>(),
            getIt.get<BookingRepository>(),
            getIt.get<RoomsOverviewMapper>(),
          ),
          settings,
        );
    }
  }

  MaterialPageRoute<void> _getRoute(
    Widget page,
    RouteSettings settings, {
    bool fullscreenDialog = false,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => page,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }
}
