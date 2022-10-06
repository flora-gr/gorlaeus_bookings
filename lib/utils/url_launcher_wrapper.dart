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

  Future<void> launchEmail(String emailAddress) async {
    await url_launcher.launchUrl(
      Uri(
        scheme: 'mailto',
        path: emailAddress,
      ),
    );
  }
}
