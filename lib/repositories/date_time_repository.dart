class DateTimeRepository {
  const DateTimeRepository();

  DateTime getCurrentDateTime() {
    return DateTime(2022, 10, 17, 10, 14); //DateTime.now();
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
