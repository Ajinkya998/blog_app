extension DateFormatter on DateTime {
  String ddMMYYYY() {
    String twoDigits(int input) => input.toString().padLeft(2, '0');
    String year = this.year.toString();
    String month = twoDigits(this.month);
    String day = twoDigits(this.day);

    return '$day-$month-$year';
  }
}
