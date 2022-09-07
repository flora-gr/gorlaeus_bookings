import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherWrapper {
  const UrlLauncherWrapper();

  Future<void> launchUrl(Uri url) async {
    await url_launcher.launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> launchEmail(
    String emailAddress, {
    String? subject,
    String? body,
  }) async {
    await url_launcher.launchUrl(
      Uri(
        scheme: 'mailto',
        path: emailAddress,
        query: subject != null || body != null
            ? <String, String>{
                if (subject != null) 'subject': subject,
                if (body != null) 'body': body,
              }
                .entries
                .map(
                  (MapEntry<String, dynamic> entry) =>
                      '${Uri.encodeComponent(entry.key)}'
                      '='
                      '${Uri.encodeComponent(entry.value.toString())}',
                )
                .join('&')
            : null,
      ),
    );
  }
}
