import 'dart:core';

class ConnectionUrls {
  // Data
  static Uri zrsSystemRequestUri =
      Uri.parse('https://zrs.leidenuniv.nl/ul/query.php');

  // Websites
  static Uri zrsWebsiteLink = Uri.https('zrs.leidenuniv.nl', '');
  static Uri githubRepositoryLink =
      Uri.https('github.com', '/flora-gr/gorlaeus_bookings');

  // Email addresses
  static const String appDeveloperEmail = 'gorlaeusbookings@gmail.com';
}
