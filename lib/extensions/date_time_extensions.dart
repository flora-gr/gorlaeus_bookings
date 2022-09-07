import 'package:intl/intl.dart';

final DateFormat _defaultDateFormat = DateFormat('dd-MM-yyyy');

extension DateTimeExtensions on DateTime {
  String get formatted => _defaultDateFormat.format(this);

  bool isOnSameDateAs(DateTime date) =>
      year == date.year && month == date.month && day == date.day;

  bool isWeekendDay() =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;
}
