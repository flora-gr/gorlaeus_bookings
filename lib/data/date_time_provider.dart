class DateTimeProvider {
  const DateTimeProvider();

  DateTime getCurrentDateTime() {
    return DateTime.now();
  }

  // TODO: unit tests
  DateTime getFirstWeekdayFromToday() {
    final DateTime today = getCurrentDateTime();
    if (today.weekday == DateTime.saturday) {
      return today.add(const Duration(days: 2));
    } else if (today.weekday == DateTime.sunday) {}
    return today;
  }
}
