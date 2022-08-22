import 'package:flutter/material.dart';

import 'package:gorlaeus_bookings/data/booking_provider.dart';
import 'package:gorlaeus_bookings/data/date_time_provider.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/bloc/booking_overview_bloc.dart';
import 'package:gorlaeus_bookings/modules/booking_overview/booking_overview_page.dart';
import 'package:gorlaeus_bookings/modules/home/bloc/home_bloc.dart';
import 'package:gorlaeus_bookings/modules/home/home_page.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';

void main() {
  runApp(const GorlaeusBookingApp());
}

class GorlaeusBookingApp extends StatelessWidget {
  const GorlaeusBookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gorlaeus Bookings',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: Routes.home,
      onGenerateRoute: (RouteSettings settings) {
        debugPrint(settings.toString());
        switch (settings.name) {
          case Routes.bookingOverviewPage:
            return getRoute(
              BookingOverviewPage(
                BookingOverviewBloc(
                  const BookingProvider(),
                  const DateTimeProvider(),
                ),
                settings.arguments as DateTime,
              ),
              settings,
            );
          case Routes.home:
          default:
            return getRoute(
              HomePage(
                HomeBloc(
                  const DateTimeProvider(),
                ),
              ),
              settings,
            );
        }
      },
    );
  }

  MaterialPageRoute<void> getRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => page,
      settings: settings,
    );
  }
}
