import 'dart:core';

class ConnectionUrls {
  const ConnectionUrls._();

  static Uri zrsSystemRequestUri =
      Uri.parse('https://zrs.leidenuniv.nl/ul/query.php');

  static Uri zrsWebsiteLink = Uri.https('zrs.leidenuniv.nl', '');

  static const String serviceDeskEmail = 'servicedesk@science.leidenuniv.nl';

  static Uri githubRepositoryLink =
      Uri.https('github.com', '/flora-gr/gorlaeus_bookings');
}
