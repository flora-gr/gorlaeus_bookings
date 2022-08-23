class Strings {
  const Strings._();

  // Home page
  static const String homePageTitle = 'Gorlaeus Bookings';
  static const String dateToCheck = 'Date to check:';
  static const String chooseADate = 'Choose a different date';
  static const String goToPageButtonText = 'Check bookings';

  // Booking overview page
  static const String bookingOverviewPageTitle = 'Bookings';
  static const String errorFetchingBookings = 'Failed to fetch bookings.';
  static const String bookingsOn = 'Bookings on';
  static const String noBookings = 'No bookings found for this day.';
  static String bookRoomEmailBody(
          String room, String dateString, String time) =>
      'Hello,\n\n'
      'I would like to book room $room $dateString from $time to ...\n\n'
      'Thanks in advance\n';

  // Booking table
  static const String free = 'Free';
  static const String booked = 'Booked';
  static const String roomFreeDialogHeader = 'This room is free';
  static const String roomBookedDialogHeader = 'Sorry!';
  static String roomFreeDialogText(String room, String time) =>
      'Do you want to book room $room at $time?';
  static const String roomBookedDialogText = 'This room is already booked.';
  static const String yesBookRoom = 'Yes, send email';
  static const String cancel = 'Cancel';
}
