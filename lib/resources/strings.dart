class Strings {
  const Strings._();

  // Home page
  static const String homePageTitle = 'Gorlaeus Bookings';

  // Booking overview tile
  static const String bookingOverview = 'Booking overview';
  static const String dateToCheck = 'Date to check:';
  static const String chooseADate = 'Choose a different date';
  static const String goToPageButtonText = 'Check bookings';

  // Disclaimer dialog
  static const String disclaimerDialogTitle = 'Disclaimer';
  static const String disclaimerDialogText1 = 'This app uses the ';
  static const String disclaimerDialogText2 = 'https://zrs.leidenuniv.nl';
  static const String disclaimerDialogText3 = ' website to fetch data. '
      'It is a hobby project and although all data is presented in good faith, it may contain errors. '
      'Usage of the booking system via this app is at your own risk.\n\n'
      'Bug reports and feature requests can be made at our ';
  static const String disclaimerDialogText4 = 'Github repository';
  static const String disclaimerDialogText5 =
      '.\n\nThanks for using Gorlaeus Bookings!';

  // Get me a free room tile
  static const String getMeAFreeRoom = 'Find a free room now';
  static const String search = 'Search';
  static String roomIsFree(String room) =>
      'Room $room is free until the end of the day.';
  static const String getFreeRoomFailed = 'Failed to find a room.';

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

  // Shared
  static const String ok = 'OK';
  static const String tryAgain = 'Try again';
}
