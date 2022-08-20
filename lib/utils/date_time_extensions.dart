import 'package:intl/intl.dart';

final DateFormat _defaultDateFormat = DateFormat('dd-MM-yyyy');

extension DateTimeExtensions on DateTime {
  String get formatted => _defaultDateFormat.format(this);
}
