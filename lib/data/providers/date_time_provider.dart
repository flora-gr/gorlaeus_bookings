class DateTimeProvider {
  const DateTimeProvider();

  DateTime getCurrentDateTime() {
    return DateTime.now();
  }

  DateTime getFirstWeekdayFromToday() {
    final DateTime today = getCurrentDateTime();
    if (today.weekday == DateTime.saturday) {
      return today.add(const Duration(days: 2));
    } else if (today.weekday == DateTime.sunday) {
      return today.add(const Duration(days: 1));
    }
    return today;
  }
}
