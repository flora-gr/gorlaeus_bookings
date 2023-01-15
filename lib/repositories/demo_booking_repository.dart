import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/repositories/booking_repository.dart';
import 'package:path_provider/path_provider.dart';

class DemoBookingRepository extends BookingRepository {
  const DemoBookingRepository();

  @override
  Future<List<BookingEntry>?> getBookingsForBuilding(
    DateTime date,
    String building,
  ) async {
    final String path = _getDataPath(building);
    final ByteData byteData = await rootBundle.load('assets/demo/$path');
    final File demoData = File('${(await getTemporaryDirectory()).path}/$path');
    await demoData.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return mapResponse(await demoData.readAsString());
  }

  String _getDataPath(String building) {
    switch (building) {
      case (BookingRepository.building1):
        return 'building1.html';
      case (BookingRepository.building2):
        return 'building2.html';
      case (BookingRepository.building3):
        return 'building3.html';
      default:
        throw (Exception());
    }
  }
}
