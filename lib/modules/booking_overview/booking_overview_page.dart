import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/data/booking_provider.dart';

class BookingOverviewPage extends StatefulWidget {
  const BookingOverviewPage({
    Key? key,
    required this.title,
    required this.bookingProvider,
  }) : super(key: key);

  final String title;
  final BookingProvider bookingProvider;

  @override
  State<BookingOverviewPage> createState() => _BookingOverviewPageState();
}

class _BookingOverviewPageState extends State<BookingOverviewPage> {
  late List<BookingEntry>? tableData;

  @override
  void initState() {
    _fillTableData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Tweede pagina'),
      ),
    );
  }

  void _fillTableData() async {
    tableData = await widget.bookingProvider.getReservation();
  }
}
