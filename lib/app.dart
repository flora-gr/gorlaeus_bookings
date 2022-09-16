import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gorlaeus_bookings/app_theme.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart' as di;
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/booking_overview_page.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/home_page.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/settings_page.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const GorlaeusBookingApp());
}

class GorlaeusBookingApp extends StatelessWidget {
  const GorlaeusBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gorlaeus Bookings',
      theme: AppTheme.themeDataLight,
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

  MaterialPageRoute<void> _onGenerateRoute(RouteSettings settings) {
    debugPrint(settings.toString());
    switch (settings.name) {
      case Routes.bookingOverviewPage:
        return _getRoute(
          BookingOverviewPage(
            BookingOverviewBloc(),
            settings.arguments as DateTime,
          ),
          settings,
        );
      case Routes.settingsPage:
        return _getRoute(
          SettingsPage(
            SettingsBloc(),
          ),
          settings,
          fullscreenDialog: true,
        );
      case Routes.homePage:
      default:
        return _getRoute(
          HomePage(
            HomeBloc(),
            GetFreeRoomNowBloc(),
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

// Temporary until zrs certificate is restored
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
