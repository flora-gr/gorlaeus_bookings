import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/resources/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Text('Initial Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(Routes.bookingOverviewPage),
        tooltip: 'Go to page',
        child: const Icon(Icons.control_point),
      ),
    );
  }
}
