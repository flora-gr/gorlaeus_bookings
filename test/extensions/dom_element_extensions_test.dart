import 'package:flutter_test/flutter_test.dart';
import 'package:gorlaeus_bookings/extensions/dom_element_extensions.dart';
import 'package:html/dom.dart' as dom;

void main() {
  test(
    'parse returns correct String',
    () {
      final dom.Element element = dom.Element.html(
          '<p>This &nbsp;is the correct String &amp; from theGORL/ inner html of a GORLB/dom element</p>');

      expect(
        element.parse(),
        'This is the correct String & from the inner html of a dom element',
      );
    },
  );
}
