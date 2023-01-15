import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/di/injection_container.dart';
import 'package:gorlaeus_bookings/extensions/dom_element_extensions.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/repositories/shared_preferences_repository.dart';
import 'package:gorlaeus_bookings/resources/connection_urls.dart';
import 'package:gorlaeus_bookings/resources/rooms.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class BookingRepository {
  const BookingRepository();

  static const String building1 = 'GORLB+GORLB - Gorlaeus Building';
  static const String building2 = 'GORL+GORL - Gorlaeus Lecture Hall';
  static const String building3 = 'HUYGENS+HUYGENS - Huygens';

  Future<List<BookingEntry>?> getBookings(DateTime date) async {
    final List<String> hiddenRooms =
        await getIt.get<SharedPreferencesRepository>().getHiddenRooms();

    final List<Future<List<BookingEntry>?>> bookingTasks =
        <Future<List<BookingEntry>?>>[
      if (Rooms.building1.any((String room) => !hiddenRooms.contains(room)))
        getBookingsForBuilding(date, building1),
      if (Rooms.building2.any((String room) => !hiddenRooms.contains(room)))
        getBookingsForBuilding(date, building2),
      if (Rooms.building3.any((String room) => !hiddenRooms.contains(room)))
        getBookingsForBuilding(date, building3)
    ];

    if (bookingTasks.isEmpty) {
      return <BookingEntry>[];
    }

    final Iterable<Iterable<BookingEntry>?> bookings =
        await Future.wait(bookingTasks);

    if (bookings.isNotEmpty &&
        bookings.length == bookingTasks.length &&
        !bookings.any((Iterable<BookingEntry>? bookingsForBuilding) =>
            bookingsForBuilding == null)) {
      return bookings
          .expand<BookingEntry>((Iterable<BookingEntry>? bookingsForBuilding) =>
              bookingsForBuilding!)
          .toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<BookingEntry>?> getBookingsForBuilding(
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
        return mapResponse(response.body);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }

  List<BookingEntry> mapResponse(String responseBody) {
    final List<BookingEntry> listOfBookings = <BookingEntry>[];

    final List<dom.Element> rows = parse(responseBody)
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
