import 'package:html/dom.dart' as dom;

extension DomElementExtensions on dom.Element {
  String parse() {
    final bla = innerHtml
        .replaceAll('&nbsp;', '')
        .replaceAll('<p>', '')
        .replaceAll('</p>', '')
        .replaceAll('&amp;', '&')
        .replaceAll('GORLB/', '')
        .replaceAll('VER', '')
        .replaceAll('SEM', '')
        .trim();
    return bla;
  }
}
