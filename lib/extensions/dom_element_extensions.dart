import 'package:html/dom.dart' as dom;

extension DomElementExtensions on dom.Element {
  String parse() {
    return innerHtml
        .replaceAll('<p>', '')
        .replaceAll('</p>', '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('GORLB/', '')
        .replaceAll('GORL/', '')
        .replaceAll('HUYGENS/', '')
        .replaceAll('VER', '')
        .replaceAll('SEM', '')
        .trim();
  }
}
