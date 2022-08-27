class DateTimeProvider {
  const DateTimeProvider();

  DateTime getCurrentDateTime() {
    return DateTime.now();
  }

  DateTime getFirstWeekdayFromToday() {
    final DateTime today = getCurrentDateTime();
    if (today.day == DateTime.saturday) {
      return today.add(const Duration(days: 2));
    } else if (today.day == DateTime.sunday) {}
    return today;
  }
}
