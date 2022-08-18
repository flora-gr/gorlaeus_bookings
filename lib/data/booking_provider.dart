import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/data/booking_entry.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class BookingProvider {
  const BookingProvider();

  Future<List<BookingEntry>?> getReservation() async {
    final url = Uri.parse('https://zrs.leidenuniv.nl/ul/query.php');
    http.post(
      url,
      body: {
        'day': '16',
        'month': '9',
        'year': '2022',
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
    ).then(
      (response) {
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
                time: _parseElement(rowElements[0]),
                room: _parseElement(rowElements[1]),
                personCount: int.tryParse(_parseElement(rowElements[3])),
                bookedOnBehalfOf: _parseElement(rowElements[4]),
                activity: _parseElement(rowElements[6]),
                user: _parseElement(rowElements[7]),
              ),
            );
          }
        }
        debugPrint('Aantal entries: ${listOfBookings.length}\n');
        for (BookingEntry d in listOfBookings) {
          debugPrint(d.toString());
        }
        return listOfBookings;
      },
    );
    return null;
  }

  String _parseElement(dom.Element element) {
    return element.innerHtml
        .replaceAll('&nbsp;', '')
        .replaceAll('<p>', '')
        .replaceAll('</p>', '')
        .replaceAll('&amp;', '&')
        .replaceAll('GORLB/', '')
        .trim();
  }
}
