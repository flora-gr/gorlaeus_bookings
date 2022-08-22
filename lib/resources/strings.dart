class Strings {
  const Strings._();

  // Home page
  static const String homePageTitle = 'Gorlaeus Bookings';
  static const String dateToCheck = 'Date to check:';
  static const String homePageText = 'Initial Home Page';
  static const String chooseADate = 'Choose a different date';
  static const String goToPageButtonText = 'Check bookings';

  // Booking overview page
  static const String bookingOverviewPageTitle = 'Bookings';
  static const String errorFetchingBookings = 'Failed to fetch bookings.';
  static const String bookingsOn = 'Bookings on';
  static const String noBookings = 'No bookings found for this day.';

  // Booking table
  static const String free = 'Free';
  static const String booked = 'Booked';
  static const String roomFreeDialogHeader = 'This room is free';
  static const String roomBookedDialogHeader = 'Sorry!';
  static String roomFreeDialogText(String room, String time) =>
      'Want to book room $room at $time?';
  static const String roomBookedDialogText = 'This room is already booked.';
  static const String yesBookRoom = 'Yes, send email';
  static const String cancel = 'Cancel';
}
