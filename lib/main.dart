import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart' as di;
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/booking_overview_page.dart';
import 'package:gorlaeus_bookings/modules/get_free_room_now/bloc/get_free_room_now_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/home_page.dart';
import 'package:gorlaeus_bookings/modules/settings/bloc/settings_bloc.dart';
import 'package:gorlaeus_bookings/modules/settings/settings_page.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';
import 'package:gorlaeus_bookings/theme/app_theme.dart';
import 'package:gorlaeus_bookings/theme/table_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  final ThemeMode themeMode =
      await getIt.get<SharedPreferencesRepository>().getThemeMode();
  runApp(App(themeMode));
}

class App extends StatelessWidget {
  const App(this.themeMode, {super.key});

  final ThemeMode themeMode;

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    themeNotifier.value = themeMode;
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Gorlaeus Bookings',
          theme: AppTheme.themeDataLight.copyWith(
              extensions: <ThemeExtension<TableColors>>[TableColorsLight()]),
          darkTheme: AppTheme.themeDataDark.copyWith(
              extensions: <ThemeExtension<TableColors>>[TableColorsDark()]),
          themeMode: currentMode,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: Routes.homePage,
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }

  MaterialPageRoute<void> _onGenerateRoute(RouteSettings settings) {
    debugPrint(settings.toString());
    switch (settings.name) {
      case Routes.bookingOverviewPage:
        return _getRoute<void>(
          BookingOverviewPage(
            BookingOverviewBloc(),
            settings.arguments as DateTime,
          ),
          settings,
        );
      case Routes.settingsPage:
        return _getRoute<bool>(
          SettingsPage(
            SettingsBloc(),
          ),
          fullscreenDialog: true,
          settings,
        );
      case Routes.homePage:
      default:
        return _getRoute<void>(
          HomePage(
            HomeBloc(),
            GetFreeRoomNowBloc(),
          ),
          settings,
        );
    }
  }

  MaterialPageRoute<void> _getRoute<T>(
    Widget page,
    RouteSettings settings, {
    bool fullscreenDialog = false,
  }) {
    return MaterialPageRoute<T>(
      builder: (_) => page,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
    );
  }
}
