import 'package:flutter/material.dart';

import 'package:gorlaeus_bookings/data/booking_provider.dart';
import 'package:gorlaeus_bookings/modules/home/home_page.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';

import 'modules/booking_overview/booking_overview_page.dart';

void main() {
  runApp(const GorlaeusBookingApp());
}

class GorlaeusBookingApp extends StatelessWidget {
  const GorlaeusBookingApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gorlaeus Bookings',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        Routes.home: (context) => const HomePage(title: 'Home'),
        Routes.bookingOverviewPage: (context) => const BookingOverviewPage(
              title: 'Overview',
              bookingProvider: BookingProvider(),
            ),
      },
    );
  }
}
