import 'package:get_it/get_it.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/date_time_repository.dart';
import 'package:gorlaeus_bookings/repositories/demo_booking_repository.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/utils/rooms_overview_mapper.dart';
import 'package:gorlaeus_bookings/utils/url_launcher_wrapper.dart';

GetIt getIt = GetIt.instance;

void init() {
  getIt.registerSingleton<BookingRepository>(const DemoBookingRepository());
  getIt.registerSingleton<DateTimeRepository>(const DateTimeRepository());
  getIt.registerSingleton<UrlLauncherWrapper>(const UrlLauncherWrapper());
  getIt.registerSingleton<SharedPreferencesRepository>(
      SharedPreferencesRepository());
  getIt.registerSingleton<RoomsOverviewMapper>(RoomsOverviewMapper());
}
