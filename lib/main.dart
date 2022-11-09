import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/app.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart' as di;
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  final ThemeMode themeMode =
      await getIt.get<SharedPreferencesRepository>().getThemeMode();
  runApp(App(themeMode));
}
