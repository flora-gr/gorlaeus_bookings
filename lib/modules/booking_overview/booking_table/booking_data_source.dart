import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gorlaeus_bookings/extensions/data_grid_cell_extensions.dart';
import 'package:gorlaeus_bookings/extensions/string_extensions.dart';
import 'package:gorlaeus_bookings/extensions/time_block_extensions.dart';
import 'package:gorlaeus_bookings/models/booking_entry.dart';
import 'package:gorlaeus_bookings/models/time_block.dart';
import 'package:gorlaeus_bookings/resources/booking_times.dart';
import 'package:gorlaeus_bookings/theme/styles.dart';
import 'package:gorlaeus_bookings/theme/table_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingDataSource extends DataGridSource {
  BookingDataSource(
    this.bookingsPerRoom,
    this.timeIfToday, {
    required this.context,
  }) {
    _bookingData = bookingsPerRoom.keys
        .map(
          (String room) => DataGridRow(
            cells: BookingTimes.all
                .map(
                  (TimeBlock bookingTime) => DataGridCell(
                    columnName: bookingTime.startTimeString(),
                    value: room,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  final Map<String, Iterable<BookingEntry?>> bookingsPerRoom;
  final TimeOfDay? timeIfToday;
  final BuildContext context;

  late List<DataGridRow> _bookingData;

  @override
  List<DataGridRow> get rows => _bookingData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (DataGridCell cell) {
          final String room = cell.room();
          final Iterable<BookingEntry?> bookings =
              cell.bookings(bookingsPerRoom);
          final bool isFree = bookings.isEmpty;
          final String? freeTime = isFree
              ? cell.freeTime(
                  bookingsPerRoom,
                  context,
                )
              : null;
          final bool isPast = cell.isPast(timeIfToday);
          return InkWell(
            onTap: () => _showBookingDialog(
              bookings: bookings,
              room: room.toLongRoomName(context),
              time: cell.columnName,
              freeTime: freeTime,
              isFree: isFree,
              isPast: isPast,
            ),
            child: Container(
              color: _getCellColor(isFree: isFree, isPast: isPast),
              alignment: Alignment.centerLeft,
              padding: Styles.padding8,
              child: Text(room.toRoomName(context)),
            ),
          );
        },
      ).toList(),
    );
  }

  Color _getCellColor({
    required bool isFree,
    required bool isPast,
  }) {
    final TableColors tableColors = Theme.of(context).extension<TableColors>()!;
    if (isPast) {
      return isFree
          ? tableColors.freeRoomEarlierColor
          : tableColors.bookedRoomEarlierColor;
    } else {
      return isFree ? tableColors.freeRoomColor : tableColors.bookedRoomColor;
    }
  }

  void _showBookingDialog({
    required Iterable<BookingEntry?> bookings,
    required String room,
    required String time,
    required String? freeTime,
    required bool isFree,
    required bool isPast,
  }) {
    showDialog(
      builder: (_) => AlertDialog(
        scrollable: true,
        title: Text(
          isFree
              ? isPast
                  ? AppLocalizations.of(context).roomFreeInPastDialogTitle
                  : AppLocalizations.of(context).roomFreeDialogTitle
              : AppLocalizations.of(context).roomBookedDialogTitle,
        ),
        content: Text(
          isFree
              ? isPast
                  ? AppLocalizations.of(context).roomFreeInPastDialogText
                  : AppLocalizations.of(context)
                      .roomFreeDialogText(room.capitalize(), freeTime!)
              : _getRoomBookedText(
                  room: room,
                  isPast: isPast,
                  bookings: bookings,
                ),
        ),
        actions: <Widget>[
          if (!isPast && isFree) ...<Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).okButton),
            ),
          ] else
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).okButton),
            ),
        ],
      ),
      context: context,
    );
  }

  String _getRoomBookedText({
    required String room,
    required bool isPast,
    required Iterable<BookingEntry?> bookings,
  }) {
    final List<BookingEntry?> uniqueBookings = bookings.toSet().toList();
    String additionalBookings = '';
    if (uniqueBookings.length > 1) {
      uniqueBookings.forEachIndexed(
        (int i, BookingEntry? booking) {
          if (i != 0) {
            String additionalBooking =
                AppLocalizations.of(context).additionalBookingDialogText(
              _getBookingSpecifications(booking!),
            );
            additionalBookings = additionalBookings + additionalBooking;
          }
        },
      );
    }

    return AppLocalizations.of(context).roomBookedDialogText(
      room.capitalize(),
      isPast
          ? AppLocalizations.of(context).roomBookedDialogVerbPast
          : AppLocalizations.of(context).roomBookedDialogVerbCurrent,
      _getBookingSpecifications(uniqueBookings.first!),
      additionalBookings,
    );
  }

  String _getBookingSpecifications(BookingEntry booking) {
    return '${booking.user.isNotEmpty ? AppLocalizations.of(context).userInformation(booking.user) : ''}'
        '${booking.activity.isNotEmpty ? AppLocalizations.of(context).activityInformation(booking.activity) : ''}'
        '${AppLocalizations.of(context).timeBlockInformation(booking.time!.asString())}';
  }
}
