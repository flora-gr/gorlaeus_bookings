import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/models/booking_entry.dart';
import 'package:gorlaeus_bookings/resources/connection_urls.dart';
import 'package:gorlaeus_bookings/extensions/dom_element_extensions.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class BookingRepository {
  const BookingRepository();

  static const String _building1 = 'GORLB+GORLB - Gorlaeus Building';
  static const String _building2 = 'GORL+GORL - Gorlaeus Lecture Hall';

  Future<List<BookingEntry>?> getBookings(DateTime date) async {
    final List<Future<List<BookingEntry>?>> bookingTasks =
        <Future<List<BookingEntry>?>>[
      _getBookings(date, _building1),
      _getBookings(date, _building2)
    ];

    try {
      final List<List<BookingEntry>?> bookings =
          await Future.wait(bookingTasks);

      if (bookings.isNotEmpty && bookings.length == 2) {
        return <BookingEntry>[
          if (bookings[0] != null) ...bookings[0]!,
          if (bookings[1] != null) ...bookings[1]!,
        ];
      }
    } on Exception {
      return null;
    }
    return null;
  }

  Future<List<BookingEntry>?> _getBookings(
    DateTime date,
    String building,
  ) async {
    try {
      final Response response = await http.post(
        ConnectionUrls.zrsSystemRequestUri,
        body: <String, String>{
          'day': date.day.toString(),
          'month': date.month.toString(),
          'year': date.year.toString(),
          'res_instantie': '_ALL_',
          'selgebouw': building,
          'zrssort': 'aanvangstijd',
          'gebruiker': '',
          'aanvrager': '',
          'activiteit': '',
          'submit': 'Uitvoeren',
        },
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng, * /*;q=0.8,application/signed-exchange;v=b3;q=0.9',
          'Accept-Encoding': 'gzip, deflate, br',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return _mapResponse(response);
      }
    } on Exception {
      return null;
    }
    return null;
  }

  List<BookingEntry> _mapResponse(Response response) {
    final List<BookingEntry> listOfBookings = <BookingEntry>[];

    final List<dom.Element> rows = parse(response.body)
        .getElementsByTagName('table')[0]
        .getElementsByTagName('tr');

    for (final dom.Element row in rows) {
      final List<dom.Element> rowElements = row.getElementsByTagName('td');
      if (rowElements.isNotEmpty &&
          !rowElements.first.innerHtml.startsWith('<font')) {
        listOfBookings.add(
          BookingEntry(
            time: rowElements[0].parse().toTimeBlock(),
            room: rowElements[1].parse(),
            personCount: int.tryParse(rowElements[3].parse()),
            bookedOnBehalfOf: rowElements[4].parse(),
            activity: rowElements[6].parse(),
            user: rowElements[7].parse(),
          ),
        );
      }
    }
    debugPrint('Number of booking entries: ${listOfBookings.length}');
    for (BookingEntry d in listOfBookings) {
      debugPrint(d.toString());
    }
    return listOfBookings;
  }
}
