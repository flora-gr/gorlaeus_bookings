class Strings {
  const Strings._();

  // Home page
  static const String homePageTitle = 'Gorlaeus Bookings';
  static const String adjustSettings = 'Adjust settings';

  // Booking overview item
  static const String bookingOverviewItemTitle = 'Booking overview';
  static const String dateToCheck = 'Date to check:';
  static const String dateSelectionButton = 'Choose a different date';
  static const String goToBookingsButton = 'Check bookings';

  // Disclaimer dialog
  static const String disclaimerDialogTitle = 'Disclaimer';
  static const String disclaimerDialogText1 = 'This app uses the ';
  static const String disclaimerDialogText2 = 'https://zrs.leidenuniv.nl';
  static const String disclaimerDialogText3 = ' website to fetch data. '
      'It is a hobby project and although all data is presented in good faith, it may contain errors. '
      'Usage of the booking system via this app is at your own risk.\n\n'
      'Feedback such as bug reports and feature requests can be ';
  static const String disclaimerDialogText4 = 'e-mailed';
  static const String disclaimerDialogText5 = ' or posted as an issue at our ';
  static const String disclaimerDialogText6 = 'Github repository';
  static const String disclaimerDialogText7 =
      '.\n\nThanks for using Gorlaeus Bookings!';

  // Get free room item
  static const String getFreeRoomItemTitle = 'Find an available room now';
  static const String searchButton = 'Search';
  static const String searchAgainButton = 'Search again';
  static const String notAvailableInWeekendButton = 'Not available on weekends';
  static const String roomIsFree1 = 'Room ';

  static String roomIsFree2(String? endTime, {required bool isOnlyRoom}) =>
      ' is available until ${endTime ?? 'end of the day'}'
      '${isOnlyRoom ? ' (the only available room within your selection)' : ''}.';
  static const String getFreeRoomFailed = 'Something went wrong. '
      'Please check your internet connection.';
  static const String noFreeRoomFound = 'No available room found. '
      'Consider adjusting your room selection in \'Settings\'.';

  // Booking overview page
  static const String bookingOverviewPageTitle = 'Bookings';
  static const String noBookingsFound = 'No bookings found. '
      'Consider adjusting your room selection in \'Settings\'.';
  static const String fetchingBookingsFailed = 'Failed to fetch bookings. '
      'Please check your internet connection.';
  static const String bookingsOn = 'Bookings on';
  static const String notLectureRoom = '\n*Not a lecture room';

  static String bookRoomEmailSubject(String room) => 'Book $room';
  static const String today = 'today';

  static String onDay(String day) => 'on $day';

  static String bookRoomEmailBody(
          String room, String dateString, String time, String? emailName) =>
      'Hello,\n\n'
      'I would like to book $room $dateString from $time to ...\n\n'
      'Thanks in advance'
      '${emailName != null && emailName.trim().isNotEmpty ? ',\n$emailName' : '\n'}';

  // Booking dialog
  static const String roomFreeDialogTitle = 'This room is available';

  static String roomFreeDialogText(String room, String time) =>
      'Do you want to book $room at $time?';
  static const String yesBookRoomButton = 'Yes, send email';
  static const String cancelButton = 'Cancel';
  static const String roomFreeInPastDialogTitle = 'This was earlier today';
  static const String roomFreeInPastDialogText =
      'Please select a different time.';

  static const String roomBookedDialogTitle = 'Booked';

  static String roomBookedDialogText(String room, bool isPast, String? user,
          String? activity, String timeBlock) =>
      '$room ${isPast ? 'was' : 'is'} booked'
      '${user?.isNotEmpty == true ? ' by $user,' : ''}'
      '${activity?.isNotEmpty == true ? ' for "$activity",' : ''}'
      ' from $timeBlock.';

  // Settings page
  static const String settingsPageTitle = 'Settings';
  static const String selectRoomsTitle = 'Select rooms';
  static const String selectRoomsInfoI =
      'Selected rooms will be shown in the \'Booking overview\' '
      'and will be suggested in \'Find an available room now\'.';
  static const String setEmailNameTitle = 'Email signature';
  static const String setEmailNameInfoI =
      'Enter the name you want to use when booking a room on the \'Booking overview\'.';
  static const String saveButton = 'Save changes';

  // Shared
  static const String okButton = 'OK';
  static const String notLectureRooms =
      '*Indicated locations are not lecture rooms';
}
