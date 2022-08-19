import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:gorlaeus_bookings/utils/dom_element_extensions.dart';
import 'package:gorlaeus_bookings/utils/string_extensions.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class BookingProvider {
  const BookingProvider();

  Future<List<BookingEntry>?> getReservations(DateTime date) async {
    final url = Uri.parse('https://zrs.leidenuniv.nl/ul/query.php');
    final Response response = await http.post(
      url,
      body: {
        'day': date.day.toString(),
        'month': date.month.toString(),
        'year': date.year.toString(),
        'res_instantie': '_ALL_',
        'selgebouw': 'GORLB+GORLB - Gorlaeus Building',
        'zrssort': 'aanvangstijd',
        'gebruiker': '',
        'aanvrager': '',
        'activiteit': '',
        'submit': 'Uitvoeren',
      },
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng, * /*;q=0.8,application/signed-exchange;v=b3;q=0.9',
        'Accept-Encoding': 'gzip, deflate, br',
      },
    );
    if (response.statusCode == 200) {
      return _mapResponse(response);
    }
    return null;
  }

  List<BookingEntry> _mapResponse(Response response) {
    final List<BookingEntry> listOfBookings = [];

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
